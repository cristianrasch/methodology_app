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
  arr = Status.constants.map {|const| const.to_s.downcase}
  arr.pop
  arr.each do |stat|
    define_method("#{stat}?") {
      status == "Project::Status::#{stat.upcase}".constantize
    }
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
    
    SELECT = [['En curso', ON_COURSE], ['Pendiente', PENDING], ['No iniciado', NOT_STARTED], 
             ['No finalizado', NOT_FINISHED], ['Finalizado', FINISHED]]
    
    class << self
      def to_s(indicator)
        arr = SELECT.find {|arr| arr.last == indicator}
        arr.first if arr
      end
    end
  end

  include DateUtils
  include AsyncEmail
  
  belongs_to :owner, :class_name => 'User'
  belongs_to :dev, :class_name => 'User', :foreign_key => :dev_id
  belongs_to :updater, :class_name => 'User', :foreign_key => :updated_by
  belongs_to :project_name
  has_many :events, :dependent => :destroy, :order => 'created_at desc'
  has_many :tasks, :dependent => :destroy do
    def list(options={})
      t = options.has_key?(:show_all) ? scoped : incomplete
      t.ordered.page(options[:page]).per(10)
    end
  end
  has_and_belongs_to_many :users

  validates :description, :presence => true
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
  validates :estimated_start_date, :presence => true
  validates :estimated_end_date, :presence => true
  validates :estimated_duration, :numericality => { :greater_than => 0 }
  validate :dates_set
  validate :participating_users
  
  scope :on_course, lambda { where(:started_on.lteq => Date.today, :ended_on => nil) }
  scope :pending, lambda { where(:estimated_start_date.gt => Date.today) }
  scope :not_started, lambda { where(:estimated_start_date.lt => Date.today, :status => Project::Status::NEW) }
  scope :not_finished, lambda { where(:estimated_end_date.lt => Date.today, :ended_on => nil) }
  scope :finished, lambda { where(:status => Project::Status::FINISHED) }
  scope :ordered, order(:started_on.desc)
  scope :developed_by, lambda { |dev| where(:dev => dev) }

  before_save :set_default_envisaged_end_date
  after_save :notify_project_saved
  
  cattr_reader :per_page
  @@per_page = 10
  attr_reader :user_tokens
  attr_accessor :indicator
  attr_accessible :description, :dev_id, :owner_id, :user_ids, :estimated_start_date, :estimated_end_date, 
                  :estimated_duration, :status, :updated_by, :user_tokens, :compl_perc, :klass, :indicator, 
                  :envisaged_end_date, :estimated_duration_unit, :project_name_id
  date_writer_for :estimated_start_date, :estimated_end_date, :envisaged_end_date
  
  class << self
    def search(template, page = nil)
      projects = scoped
      
      [:dev_id, :owner_id, :project_name_id].each { |col|
        projects = projects.where(col => template.send(col)) if template.send(col).present?
      }
    
      projects = projects.where(:started_on >= template.started_on) if template.started_on.present?
      projects = projects.where(:estimated_end_date <= template.estimated_end_date) if template.estimated_end_date.present?
    
      if template.indicator.present?
        arr = Project::Indicator.constants.map {|const| const.to_s.downcase}
        arr.pop
        arr.each { |ind| projects = projects.send(ind) if template.indicator.to_i == "Project::Indicator::#{ind.upcase}".constantize }
      end
    
      projects.ordered.page(page).per(per_page)
    end
    
    def search_for(user, page = nil)
      projects = user.dev? ? developed_by(user) : scoped
      projects.on_course.ordered.page(page).per(Project.per_page)
    end
  end
  
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end
  
  def to_s
    project_name.to_s 
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
      # FIXME: should split into hours, days & weeks
      self.actual_duration = events.sum(:duration) + tasks.sum(:duration)
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
  
  private
  
  def dates_set
    if estimated_start_date && estimated_end_date && estimated_start_date > estimated_end_date
      errors.add(:estimated_end_date)
    end
    errors.add(:envisaged_end_date) if envisaged_end_date && started_on && envisaged_end_date < started_on 
  end
  
  def participating_users
    errors.add(:user_ids, I18n.t('errors.messages.empty')) if user_ids.empty?
  end
  
  def notify_project_saved
    send_async(ProjectNotifier, :project_saved, self)
  end
  
  def set_default_envisaged_end_date
    self.envisaged_end_date = estimated_end_date unless envisaged_end_date
  end
end
