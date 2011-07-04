# coding: utf-8

class Project < ActiveRecord::Base
  class Status
    NEW = 1
    IN_DEV = 2
    STOPPED = 3
    CANCELED = 4
    FINISHED = 5
    
    SELECT = [['Nuevo', NEW], ['En desarrollo', IN_DEV], ['Detenido', STOPPED], 
              ['Cancelado', CANCELED], ['Terminado', FINISHED]]
  end
  
  class Klass
    DEV = 1
    IMPR = 2
    PROC = 3
    
    SELECT = [['Desarrollo', DEV], ['Valorización', IMPR], ['Proceso', PROC]]
  end
  
  class Indicator
    ON_COURSE = 1
    PENDING = 2
    NOT_STARTED = 3
    NOT_FINISHED = 4
    FINISHED = 5
    COMMITTED = 6
    
    SELECT = [['En curso', ON_COURSE], ['Pendiente', PENDING], ['No iniciado', NOT_STARTED], 
             ['No finalizado', NOT_FINISHED], ['Finalizado', FINISHED], ['Comprometido', COMMITTED]]
    
    class << self
      def to_s(indicator)
        arr = SELECT.find {|arr| arr.last == indicator}
        arr.first if arr
      end
    end
  end

  has_paper_trail :only => [:envisaged_end_date]

  include DateUtils
  include AsyncEmail
  include Duration
  
  belongs_to :owner, :class_name => 'User'
  belongs_to :dev, :class_name => 'User', :foreign_key => :dev_id
  belongs_to :updater, :class_name => 'User', :foreign_key => :updated_by
  belongs_to :project_name
  belongs_to :org_unit
  has_many :events, :dependent => :destroy, :order => 'id desc'
  has_many :tasks, :dependent => :destroy do
    def list(options={})
      t = options.has_key?(:show_all) ? scoped : incomplete
      t.ordered.page(options[:page]).per(10)
    end
  end
  has_and_belongs_to_many :users

  validates :req_nbr, :numericality => { :greater_than => 0, 
                                         :message => I18n.t('errors.messages.blank') },
                      :uniqueness => { :allow_nil => true }
  validates :compl_perc, :numericality => { :greater_than_or_equal_to => 0, 
                                            :message => I18n.t('errors.messages.blank') }
  validates :klass, :numericality => { :greater_than => 0, 
                                       :message => I18n.t('errors.messages.blank') }
  validates :dev_id, :numericality => { :greater_than => 0, 
                                        :message => I18n.t('errors.messages.blank') }
  validates :owner_id, :numericality => { :greater_than => 0, 
                                          :message => I18n.t('errors.messages.blank') }
  validates :project_name_id, :numericality => { :greater_than => 0, 
                                                 :message => I18n.t('errors.messages.blank') }
  validates :org_unit_id, :numericality => { :greater_than => 0, 
                                             :message => I18n.t('errors.messages.blank') }
  validates :estimated_start_date, :presence => true
  validates :estimated_end_date, :presence => true
  validates :estimated_duration, :numericality => { :greater_than => 0 }
  validates :requirement, :presence => true
  validate :dates_set
  validate :devs_and_owners_email_address
  validate :owner_not_among_users
  
  def indicator_class_for(project)
    return 'green' if project.started_on <= Date.today &&  project.in_dev?
    return 'yellow' if project.estimated_start_date > Date.today
    return 'red' if project.estimated_start_date < Date.today && project.new?
    return 'black' if project.estimated_end_date < Date.today && ! project.finished?
    return 'blue' if project.finished?
  end
  
  scope :on_course, lambda { where(:started_on <= Date.today, :status => Status::IN_DEV) }
  scope :pending, lambda { where(:estimated_start_date > Date.today, :status => Status::NEW) }
  scope :not_started, lambda { where(:estimated_start_date < Date.today, :status => Status::NEW) }
  scope :not_finished, lambda { committed.where(:estimated_end_date < Date.today) }
  scope :finished, lambda { where(:status => Status::FINISHED) }
  scope :ordered, order(:req_nbr.desc)
  scope :developed_by, lambda { |dev_id| where(:dev_id => dev_id) }
  scope :upcoming, lambda { where(:status => Status::NEW) }
  scope :on_est_course_by, lambda { |date| where(['? between estimated_start_date and estimated_end_date', date]) }
  scope :on_course_by, lambda { |date| where(['? between estimated_start_date and envisaged_end_date', date]) }
  scope :committed, where(:status.not_in => [Status::CANCELED, Status::FINISHED])
  scope :compl_perc_has_not_been_updated_since_last_week, lambda { joins(:dev).
                                                                   where(:dev => {:username => Conf.devs.split(',')}).
                                                                   where(:last_compl_perc_update_at < 1.week.ago) }

  before_create :touch_last_compl_perc_update
  before_save :set_default_envisaged_end_date
  after_update :create_first_event
  after_update :stop_current_event
  after_save :notify_project_saved
  
  cattr_reader :per_page
  @@per_page = 20
  attr_reader :user_tokens, :notify_envisaged_end_date_changed
  attr_writer :notify_envisaged_end_date_changed
  attr_accessor :indicator
  attr_accessible :description, :dev_id, :owner_id, :user_ids, :estimated_start_date, :estimated_end_date, 
                  :estimated_duration, :status, :updated_by, :user_tokens, :compl_perc, :klass, :indicator, 
                  :envisaged_end_date, :estimated_duration_unit, :project_name_id, :requirement, 
                  :org_unit_id, :req_nbr, :notify_envisaged_end_date_changed
  date_writer_for :estimated_start_date, :estimated_end_date, :envisaged_end_date
  
  class << self
    def search(template, options = {})
      projects = scoped
      
      if template.project_name_id.present?
        projects = projects.where(:project_name_id => ProjectName.subtree_of(template.project_name_id).map(&:id))
      end
      
      [:dev_id, :owner_id].each { |col|
        projects = projects.where(col => template.send(col)) if template.send(col).present?
      }
    
      projects = projects.where(:started_on >= template.started_on) if template.started_on.present?
      projects = projects.where(:estimated_end_date <= template.estimated_end_date) if template.estimated_end_date.present?
    
      if template.indicator.present?
        arr = Project::Indicator.constants.map {|const| const.to_s.downcase}.sort
        arr.pop
        arr.each { |ind| projects = projects.send(ind) if template.indicator.to_i == "Project::Indicator::#{ind.upcase}".constantize }
      end
    
      if options[:order]
        projects = projects.order(options[:order])
      else
        projects = projects.ordered
      end
      
      projects.page(options[:page]).per(per_page)
    end
    
    def search_for(user)
      if user.dev?
        projects = developed_by(user.id)
      else
        projects = scoped
      end
    
      projects_by_dev = projects.on_course.includes(:dev, :events, :project_name).group_by(&:dev)
      
      projects_by_dev.keys.sort{|dev1, dev2| dev1.name <=> dev2.name}.map { |dev|
        projects_by_dev[dev].sort{|pr1, pr2| pr2.req_nbr <=> pr1.req_nbr}
      }.flatten
    end
    
    def by_dev
      projects_by_dev = {}
      keys = [:on_course, :pending, :stopped]
      
      committed_by_dev = committed.includes(:dev, :project_name).group_by(&:dev)
      devs = committed_by_dev.keys.sort{|dev1, dev2| dev1.name <=> dev2.name}
      
      devs.each do |dev|
        projects_by_dev[dev] = {}
        keys.each { |key| projects_by_dev[dev][key] = [] }
        
        committed_by_dev[dev].each do |project|
          keys.each do |key| 
            if project.send("#{key}?")
              projects_by_dev[dev][key] << project
              break
            end
          end
        end
      end
      projects_by_dev.each do |dev, projects|
        projects[:on_course].sort! { |pr1, pr2| pr1.started_on <=> pr2.started_on }
        projects[:pending].sort! { |pr1, pr2| pr1.estimated_start_date <=> pr2.estimated_start_date }
      end
    end
    
    def notify_devs_compl_perc_has_not_been_updated_since_last_week
      on_course.compl_perc_has_not_been_updated_since_last_week.order(:last_compl_perc_update_at).
                group_by(&:dev).each { |dev, projects|
        Notifications.compl_perc_has_not_been_updated_since_last_week(dev, projects).deliver
      }
    end
    
    def library
      Project.includes([:project_name, {:events => :documents}]).
                        order(:req_nbr.desc, :documents => [:event_id.desc, :created_at.desc]).all.
                        select {|project| ! project.documents.empty?}
    end
  end
  
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end
  
  def to_s
    "##{req_nbr} - [#{project_name}] - #{requirement.humanize}"
  end
  
  def all_users
    users(true).to_a.push(dev, owner)
  end
  
  def attributes=(attrs)
    keys = [:status, :compl_perc]
    if keys.any? { |key| attrs.has_key?(key) }
      updated_by_dev = attrs[:updated_by].to_i == (attrs.has_key?(:dev_id) ? attrs[:dev_id].to_i : dev.id)
      if !updated_by_dev || (attrs[:status].to_i == Status::FINISHED && new?)
        keys.each { |key| attrs.delete(key) }
      end
    end
    
    # unless (attrs.has_key?(:status) ? attrs[:status].to_i : status) == Status::NEW
    #   cols = Project.column_names.map(&:to_sym)
    #   cols.delete(:compl_perc)
    #   cols.delete(:status)
    #   cols.delete(:envisaged_end_date)
    #   cols.each { |col| attrs.delete(col) }
    # end
    
    if [Status::NEW, Status::FINISHED].include?(attrs.has_key?(:status) ? attrs[:status].to_i : status)
      attrs.delete(:compl_perc)
    end
    
    super
    
    @notify_envisaged_end_date_changed = attrs[:notify_envisaged_end_date_changed].to_i == 1 && envisaged_end_date_changed? && persisted?
    
    if new? && estimated_duration
      self.estimated_end_date = in_days(self, :estimated_duration).business_days.after(estimated_start_date-1).to_date
    end
  end
  
  def status=(stat)
    if stat.to_i == Status::IN_DEV
      self.started_on = Date.today unless started_on
    elsif stat.to_i == Status::FINISHED
      self.compl_perc = 100
      self.ended_on = Date.today
      self.actual_duration = events.map(&:duration_in_days).sum + tasks.map(&:duration_in_days).sum
    end
    super
  end
  
  def compl_perc=(perc)
    super
    self.last_compl_perc_update_at = Time.now
  end
  
  def status_str
    arr = Status::SELECT.find {|arr| arr.last == status}
    arr.first if arr
  end
  
  def klass_str
    arr = Klass::SELECT.find {|arr| arr.last == klass}
    arr.first if arr
  end
  
  def library_empty?
    events.inject(0) { |sum, event|
      sum += event.documents.length
    }.zero?
  end
  
  def new?
    status == Status::NEW
  end
  alias_method :pending?, :new?
  
  def in_dev?
    status == Status::IN_DEV
  end
  
  def stopped?
    status == Status::STOPPED
  end
  
  def finished?
    status == Status::FINISHED
  end
  
  def on_course?
    started_on && started_on <= Date.today && in_dev?
  end
  
  def documents
    events.map(&:documents).flatten
  end
  
  def envisaged_end_date_from(date)
    date ||= estimated_start_date
    in_days(self, :estimated_duration).business_days.after(date).to_date
  end
  
  def status_indicator
    if in_dev?
      days_from_start_to_finish = started_on.business_days_until(envisaged_end_date)
      if days_from_start_to_finish.zero?
        :red
      else
        days_since_started = started_on.business_days_until(Date.today)
        expected_compl_perc = ((days_since_started*100)/days_from_start_to_finish).round
        expected_min_compl_perc = expected_compl_perc - (expected_compl_perc*10)/100
        compl_perc < expected_min_compl_perc ? :red : (compl_perc >= expected_min_compl_perc && compl_perc < expected_compl_perc ? :yellow : :green)
      end
    end
  end
  
  private
  
  def dates_set
    if estimated_start_date && estimated_end_date && estimated_start_date > estimated_end_date
      errors.add(:estimated_end_date)
    end
    errors.add(:envisaged_end_date) if envisaged_end_date && started_on && envisaged_end_date < started_on 
  end
  
  def notify_project_saved
    send_async(ProjectNotifier, :project_saved, self) if created_at == updated_at || @notify_envisaged_end_date_changed
  end
  
  def set_default_envisaged_end_date
    self.envisaged_end_date = estimated_end_date unless envisaged_end_date
  end
  
  def devs_and_owners_email_address
    %w[dev owner].each { |attr|
      errors.add("#{attr}_id", I18n.t('errors.messages.invalid_email_address')) if send(attr) && send(attr).email.nil?
    }
  end
  
  def owner_not_among_users
    errors.add(:owner_id) if errors[:owner_id].empty? && users.include?(owner)
  end
  
  def create_first_event
    if status_changed? && status_was == Status::NEW && in_dev?
      event = events.build(:stage => Event::Stage::DEFINITION, :status => Event::Status::IN_DEV)
      event.author_id = dev_id
      event.save
    end
  end
  
  def stop_current_event
    if status_changed? && stopped?
      curr_event = events.last
      curr_event.stop if curr_event
    end
  end
  
  def touch_last_compl_perc_update
    self.last_compl_perc_update_at = Time.now
  end
end
