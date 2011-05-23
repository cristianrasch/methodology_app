class Report
  
  class Type
    WORKLOAD_BY_DEV = 1
  end
  
  include Duration
  include ActionView::Helpers::DateHelper
  
  def initialize(type)
    @type = type
  end
  
  def graph_data
    case @type
      when Type::WORKLOAD_BY_DEV then workload_by_dev
    end
  end
  
  private
  
  def workload_by_dev
    Project.group(:dev_id).order(:envisaged_end_date.desc, :id.desc).includes(:dev).map { |project|
      [project.dev.to_s, project.envisaged_end_date.to_time.to_i*1000]
    }
  end
end
