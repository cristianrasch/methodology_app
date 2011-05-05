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
  
    Project.class_eval do
      arr = Project::Status.constants.map {|const| const.to_s.downcase}
      arr.pop
      arr.each do |stat|
        define_method("#{stat}?") {
          status == "Project::Status::#{stat.upcase}".constantize
        }
      end
    end
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
    
    SELECT = [['En curso', ON_COURSE], ['Pendiente', PENDING], ['No iniciado', NOT_STARTED], 
             ['No finalizado', NOT_FINISHED]]
    
    Project.class_eval do
      arr = Project::Indicator.constants.map {|const| const.to_s.downcase}
      arr.pop
      arr.each do |ind|
        define_method("#{ind}?") {
          indicator == "Project::Indicator::#{ind.upcase}".constantize
        }
      end
    end
    
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
  has_many :events, :dependent => :destroy, :order => 'created_at desc'
  has_many :tasks, :dependent => :destroy do
    def list(options={})
      t = options.has_key?(:show_all) ? scoped : incomplete
      t.ordered.page(options[:page]).per(10)
    end
  end
  has_and_belongs_to_many :users

  validates :org_unit, :presence => true
  validates :area, :presence => true
  validates :first_name, :presence => true
  validates :description, :presence => true
  validates :compl_perc, :numericality => { :greater_than_or_equal_to => 0, 
                                            :message => I18n.t('errors.messages.blank') }
  validates :klass, :numericality => { :greater_than => 0, 
                                       :message => I18n.t('errors.messages.blank') }
  validates :dev_id, :numericality => { :greater_than => 0, 
                                        :message => I18n.t('errors.messages.blank') }
  validates :owner_id, :numericality => { :greater_than => 0, 
                                          :message => I18n.t('errors.messages.blank') }
  validates :estimated_start_date, :presence => true
  validates :estimated_end_date, :presence => true
  validates :estimated_duration, :numericality => { :greater_than => 0 }
  validate :estimated_dates
  validate :dates
  validate :implicated_users
  
  scope :on_course, lambda { where(:started_on.lteq => Date.today, :ended_on => nil) }
  scope :pending, lambda { where(:estimated_start_date.gt => Date.today) }
  scope :not_started, lambda { where(:estimated_start_date.lt => Date.today, :status => Project::Status::NEW) }
  scope :not_finished, lambda { where(:estimated_end_date.lt => Date.today, :ended_on => nil) }
  scope :ordered, order(:started_on.desc, :first_name, :last_name)
  scope :developed_by, lambda { |dev| where(:dev => dev) }
  scope :by_area, group('area') 
  
  after_save :notify_project_saved
  
  cattr_reader :per_page
  @@per_page = 10
  attr_reader :user_tokens
  attr_accessor :indicator
  attr_accessible :org_unit, :area, :first_name, :last_name, :description, :dev_id, :owner_id, :user_ids,
                  :estimated_start_date, :estimated_end_date, :estimated_duration, :status, :updated_by,
                  :user_tokens, :compl_perc, :klass, :indicator
  
  class << self
    def search(template, page = nil)
      projects = scoped
      
      [:org_unit, :area, :dev_id, :owner_id].each { |col|
        projects = projects.where(col => template.send(col)) if template.send(col).present?
      }
    
      [:first_name, :last_name].each { |col|
        projects = projects.where(col.matches => "%#{template.send(col)}%") if template.send(col).present?
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
    last_name.blank? ? first_name : first_name+' - '+last_name
  end
  
  %w{estimated_start_date estimated_end_date started_on ended_on}.each do |attr|
    define_method("#{attr}=") do |date|
      if date.is_a?(Date)
        write_attribute(attr, date)
      else
        write_attribute(attr, (date.blank? ? nil : format_date(date)))
      end
    end
  end
  
  def all_users
    users(true).to_a.push(dev, owner)
  end
  
  def attributes=(attrs)
    attrs.delete(:compl_perc) if attrs[:status].to_i == Status::NEW
    attrs.delete(:status) if attrs.has_key?(:status) && (attrs[:updated_by].to_i != (attrs.has_key?(:dev_id) ? attrs[:dev_id].to_i : dev.id))
    super
  end
  
  def status=(stat)
    if stat.to_i == Status::IN_DEV
      self.started_on = Date.today
    elsif stat.to_i == Status::FINISHED
      self.actual_duration = events.sum(:duration) + tasks.sum(:duration)
      self.ended_on = Date.today
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
  
  def estimated_dates
    if estimated_start_date && estimated_end_date && estimated_start_date > estimated_end_date
      errors.add(:estimated_end_date)
    end
  end
  
  def dates
    if started_on && ended_on && started_on > ended_on
      errors.add(:ended_on)
    end
  end
  
  def implicated_users
    errors.add(:user_ids, I18n.t('errors.messages.empty')) if user_ids.empty?
  end
  
  def notify_project_saved
    send_async(ProjectNotifier, :project_saved, self)
  end
end
