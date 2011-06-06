class Event < ActiveRecord::Base

  class Stage
    DEFINITION = 1
    FUNC_DESIGN = 2
    DEMO = 3
    TESTING = 4
    PRESENTATION = 5
    ACCEP_TESTING = 6
    IMPLEMENTATION = 8
    
    SELECT = [['Definición',DEFINITION], ['Diseño funcional', FUNC_DESIGN], ['Demostración', DEMO], 
              ['Testing', TESTING], ['Presentación', PRESENTATION], ['Prueba de usuario', ACCEP_TESTING], 
              ['Implementación', IMPLEMENTATION]]
              
    MINI_SELECT = [['Def',DEFINITION], ['Diseño', FUNC_DESIGN], ['Demo', DEMO], 
                  ['Test', TESTING], ['Pres', PRESENTATION], ['Prueba', ACCEP_TESTING], 
                  ['Impl', IMPLEMENTATION]]
  end
  
  class Status
    IN_DEV = 1
    APPR_PENDING = 2
    APPROVED = 3
    STOPPED = 4
    REJECTED = 5
    
    SELECT = [['En desarrollo', IN_DEV], ['Pendiente de aprobación', APPR_PENDING], ['Aprobado', APPROVED], 
              ['Detenido', STOPPED], ['Rechazado', REJECTED]]
              
    MINI_SELECT = [['Desar', IN_DEV], ['Pend', APPR_PENDING], ['Apr', APPROVED], 
                  ['Det', STOPPED], ['Recha', REJECTED]]
  end
    
  include Commentable
  include AsyncEmail

  belongs_to :project
  belongs_to :author, :class_name => 'User'
  has_many :comments, :as => :commentable, :dependent => :delete_all
  has_many :documents, :dependent => :delete_all, :order => 'id desc'

  validates :stage, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank') }
  validates :status, :numericality => { :greater_than => 0, :message => I18n.t('errors.messages.blank') }
  validates :project_id, :numericality => true
  validates :author_id, :numericality => true
  
  scope :ordered, order(:id.desc)
  
  after_save :notify_event_saved

  attr_accessible :stage, :status

  def to_s
    self.class.human_attribute_name(:stage)+': '+
    stage_str+' - '+
    self.class.human_attribute_name(:status)+': '+
    status_str
  end
  
  def stage_str(format = :default)
    arr = (format == :default ? Stage::SELECT : Stage::MINI_SELECT).find {|arr| arr.last == stage}
    arr.first if arr
  end

  def status_str(format = :default)
    arr = (format == :default ? Status::SELECT : Status::MINI_SELECT).find {|arr| arr.last == status}
    arr.first if arr
  end
  
  def duration_in_days
    documents.inject(0) { |sum, doc|
      sum += doc.duration_in_days
    }
  end
  
  def stop
    update_attribute(:status, Status::STOPPED)
  end
  
  private
  
  def notify_event_saved
    send_async(EventNotifier, :event_saved, self)
  end
end
