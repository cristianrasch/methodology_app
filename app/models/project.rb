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

  include DateUtils
  include AsyncEmail
  include Duration
  
  belongs_to :owner, :class_name => 'User'
  belongs_to :dev, :class_name => 'User', :foreign_key => :dev_id
  belongs_to :updater, :class_name => 'User', :foreign_key => :updated_by
  belongs_to :project_name
  belongs_to :delayed_by_proj, :class_name => 'Project', :foreign_key => :delayed_by
  belongs_to :org_unit
  has_many :events, :dependent => :destroy, :order => 'created_at desc'
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
  validate :dates_set
  validate :devs_and_owners_email_address
  validates :requirement, :presence => true
  
  def indicator_class_for(project)
    return 'green' if project.started_on <= Date.today &&  ! project.finished?
    return 'yellow' if project.estimated_start_date > Date.today
    return 'red' if project.estimated_start_date < Date.today && project.new?
    return 'black' if project.estimated_end_date < Date.today && ! project.finished?
    return 'blue' if project.finished?
  end
  
  scope :on_course, lambda { committed.where(:started_on <= Date.today) }
  scope :pending, lambda { where(:estimated_start_date > Date.today, :status => Project::Status::NEW) }
  scope :not_started, lambda { where(:estimated_start_date < Date.today, :status => Project::Status::NEW) }
  scope :not_finished, lambda { committed.where(:estimated_end_date < Date.today) }
  scope :finished, lambda { where(:status => Project::Status::FINISHED) }
  scope :ordered, order(:req_nbr.desc)
  scope :developed_by, lambda { |dev_id| where(:dev_id => dev_id) }
  scope :upcoming, lambda { where(:status => Project::Status::NEW) }
  scope :on_course_by, lambda { |date| where(['? between estimated_start_date and estimated_end_date', date]) }
  scope :on_course_or_pending, lambda { where('(started_on <= :date and status not in (:status)) or estimated_start_date > :date', :date => Date.today, :status => [Status::CANCELED, Status::FINISHED]) }
  scope :committed, where(:status - [Project::Status::CANCELED, Project::Status::FINISHED])

  before_save :set_default_envisaged_end_date
  after_save :notify_project_saved
  after_save :update_schedule_if_necessary
  
  cattr_reader :per_page
  @@per_page = 10
  attr_reader :user_tokens
  attr_accessor :indicator
  attr_accessible :description, :dev_id, :owner_id, :user_ids, :estimated_start_date, :estimated_end_date, 
                  :estimated_duration, :status, :updated_by, :user_tokens, :compl_perc, :klass, :indicator, 
                  :envisaged_end_date, :estimated_duration_unit, :project_name_id, :delayed_by, :requirement, 
                  :org_unit_id, :req_nbr
  date_writer_for :estimated_start_date, :estimated_end_date, :envisaged_end_date
  
  class << self
    def search(template, options = {})
      projects = scoped
      
      [:dev_id, :owner_id, :project_name_id].each { |col|
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
    
    def search_for(user, page = nil)
      if user.dev?
        projects = developed_by(user.id)
      elsif user.boss?
        projects = group(:dev_id).includes(:dev, :events)
      else
        projects = scoped
      end
    
      projects.on_course.ordered.page(page).per(Project.per_page)
    end
    
    def by_dev
      on_course_or_pending.joins(:dev).order(:estimated_start_date).group_by(&:dev)
    end
  end
  
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end
  
  def to_s
    "[#{project_name}] - #{requirement.humanize}" 
  end
  
  def all_users
    users(true).to_a.push(dev, owner)
  end
  
  def attributes=(attrs)
    if attrs.has_key?(:status)
      updated_by_dev = attrs[:updated_by].to_i == (attrs.has_key?(:dev_id) ? attrs[:dev_id].to_i : dev.id)
      attrs.delete(:status) if !updated_by_dev || (attrs[:status].to_i == Status::FINISHED && new?)
    end
    
    unless (attrs.has_key?(:status) ? attrs[:status].to_i : status) == Status::NEW
      cols = Project.column_names.map(&:to_sym)
      cols.delete(:compl_perc)
      cols.delete(:status)
      cols.delete(:envisaged_end_date)
      cols.each { |col| attrs.delete(col) }
    end
    
    if [Status::NEW, Status::FINISHED].include?(attrs.has_key?(:status) ? attrs[:status].to_i : status)
      attrs.delete(:compl_perc)
    end
    super
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
  
  def status_str
    arr = Status::SELECT.find {|arr| arr.last == status}
    arr.first if arr
  end
  
  def klass_str
    arr = Klass::SELECT.find {|arr| arr.last == klass}
    arr.first if arr
  end
  
  def library_empty?
    empty = true
    events.each do |event|
      1.upto(3) { |i|
        empty = false and break if event.send("attachment#{i}?") 
      }      
    end
    empty
  end
  
  def new?
    status == Status::NEW
  end
  
  def stopped?
    status == Status::STOPPED
  end
  
  def finished?
    status == Status::FINISHED
  end
  
  private
  
  def dates_set
    if estimated_start_date && estimated_end_date && estimated_start_date > estimated_end_date
      errors.add(:estimated_end_date)
    end
    errors.add(:envisaged_end_date) if envisaged_end_date && started_on && envisaged_end_date < started_on 
  end
  
  def notify_project_saved
    if created_at == updated_at || Project.column_names.grep(/_date$/).any? {|attr| send("#{attr}_changed?")}
      send_async(ProjectNotifier, :project_saved, self)
    end
  end
  
  def set_default_envisaged_end_date
    self.envisaged_end_date = estimated_end_date unless envisaged_end_date
  end
  
  def update_schedule_if_necessary
    if estimated_start_date_changed?
      delay = in_days(self, :estimated_duration)
      affected_projects = self.class.where(:id ^ id).upcoming.on_course_by(estimated_start_date).developed_by(dev_id)
      affected_projects.each { |project|
        project.update_attributes(:envisaged_end_date => delay.business_days.after(project.envisaged_end_date).to_date,
                                  :delayed_by => id)
      }
    end
    
    if envisaged_end_date_changed? && envisaged_end_date_was
      delay = (envisaged_end_date - envisaged_end_date_was).to_i
      change = delay > 0 ? envisaged_end_date_was.business_days_until(envisaged_end_date) : envisaged_end_date.business_days_until(envisaged_end_date_was)
      self.class.where(:delayed_by => id).each { |project|
        project.update_attribute(:envisaged_end_date, change.business_days.send(delay > 0 ? :after : :before, project.envisaged_end_date).to_date)
      }
    end
  end
  
  def devs_and_owners_email_address
    errors.add(:dev_id, I18n.t('errors.messages.invalid_email_address')) if dev && dev.email.nil?
    errors.add(:owner_id, I18n.t('errors.messages.invalid_email_address')) if owner && owner.email.nil?
  end
end
