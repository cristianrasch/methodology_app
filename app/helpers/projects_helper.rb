module ProjectsHelper

  def project_date(date)
    date ? l(date) : nil
  end
  
end
