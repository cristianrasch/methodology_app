class Report
  
  class Type
    WORKLOAD_BY_DEV = 1
  end
  
  include Duration
  include ActionView::Helpers::DateHelper
  
  def initialize(type)
    @type = type.to_i
  end
  
  def graph_data
    case @type
      when Type::WORKLOAD_BY_DEV then workload_by_dev
    end
  end
  
  private
  
  def workload_by_dev
    Project.count_by_dev
  end
end
