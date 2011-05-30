pr = Project.create!(:req_nbr => 291,
                     :project_name_id => ProjectName.find_or_create_by_text('Administración').id,
                     :org_unit_id => OrgUnit.find_by_text('Administración').id,
                     :requirement => 'SUB Interfase bejerman integra. correc de registro',
                     :klass => Project::Klass::PROC, :dev_id => mpa.id, :owner_id => crg.id,
                     :estimated_start_date => Date.civil(2011,5,11), :estimated_end_date => 1.week.from_now.to_date,
                     :estimated_duration => 1, :estimated_duration_unit => Duration::HOUR)
pr.update_attributes(:status => Project::Status::IN_DEV, :updated_by => mpa.id)
pr.update_attributes(:status => Project::Status::FINISHED, :updated_by => mpa.id)

pr = Project.create!(:req_nbr => 290,
                     :project_name_id => ProjectName.find_or_create_by_text('Legalizaciones').id,
                     :org_unit_id => OrgUnit.find_by_text('Legalizaciones').id,
                     :requirement => 'Query inscriptos comicios',
                     :klass => Project::Klass::PROC, :dev_id => gbe.id, :owner_id => est.id,
                     :created_at => Date.civil(2011,5,11).to_time,
                     :estimated_start_date => Date.civil(2011,5,11), :estimated_end_date => 2.weeks.from_now.to_date,
                     :estimated_duration => 2, :estimated_duration_unit => Duration::HOUR)
pr.update_attributes(:status => Project::Status::IN_DEV, :updated_by => gbe.id)

Project.create!(:req_nbr => 289,
                :project_name_id => ProjectName.find_or_create_by_text('Gcia Administración').id,
                :org_unit_id => OrgUnit.find_by_text('Administración').id,
                :requirement => 'Citi Compras ',
                :klass => Project::Klass::DEV, :dev_id => crr.id, :owner_id => est.id,
                :created_at => Date.civil(2011,5,11).to_time,
                :estimated_start_date => Date.civil(2011,6,6), :estimated_end_date => 1.month.from_now.to_date,
                :estimated_duration => 2, :estimated_duration_unit => Duration::WEEK)

pr = Project.create!(:req_nbr => 288,
                     :project_name_id => ProjectName.find_or_create_by_text('Gcia Coordinadora').id,
                     :org_unit_id => OrgUnit.find_by_text('Administración').id,
                     :requirement => 'Turnero Documentos - Agregar Feriado',
                     :klass => Project::Klass::PROC, :dev_id => fol.id, :owner_id => nss.id,
                     :created_at => Date.civil(2011,5,11).to_time,
                     :estimated_start_date => Date.civil(2011,5,11), :estimated_end_date => 5.days.from_now.to_date,
                     :estimated_duration => 2, :estimated_duration_unit => Duration::HOUR)
pr.update_attributes(:status => Project::Status::IN_DEV, :updated_by => fol.id)
pr.update_attributes(:status => Project::Status::FINISHED, :updated_by => fol.id)

pr = Project.create!(:req_nbr => 287,
                     :project_name_id => ProjectName.find_or_create_by_text('Gcia Técnica').id,
                     :org_unit_id => OrgUnit.find_by_text('Técnica').id,
                     :requirement => 'Video en internet - Presunciones de la Seg Social',
                     :klass => Project::Klass::DEV, :dev_id => gbe.id, :owner_id => tks.id,
                     :created_at => Date.civil(2011,5,10).to_time,
                     :estimated_start_date => Date.civil(2011,5,9), :estimated_end_date => 2.weeks.from_now.to_date,
                     :estimated_duration => 2, :estimated_duration_unit => Duration::DAY)
pr.update_attributes(:status => Project::Status::IN_DEV, :updated_by => gbe.id)

Project.create!(:req_nbr => 280,
                :project_name_id => ProjectName.find_or_create_by_text('Desarrollo profesional').id,
                :org_unit_id => OrgUnit.find_by_text('Desarrollo Profesional').id,
                :requirement => 'Encuesta Nuevo Matric - nuevos campos',
                :klass => Project::Klass::IMPR, :dev_id => fol.id, :owner_id => gig.id,
                :created_at => Date.civil(2011,5,3).to_time,
                :estimated_start_date => Date.civil(2011,6,1), :estimated_end_date => 3.weeks.from_now.to_date,
                :estimated_duration => 6, :estimated_duration_unit => Duration::DAY)

pr = Project.create!(:req_nbr => 274,
                     :project_name_id => ProjectName.find_or_create_by_text('EEC').id,
                     :org_unit_id => OrgUnit.find_by_text('Escuela de Educación Continuada').id,
                     :requirement => 'Plataforma materiales EEC',
                     :klass => Project::Klass::DEV, :dev_id => pap.id, :owner_id => gem.id,
                     :created_at => Date.civil(2011,4,27).to_time,
                     :estimated_start_date => Date.civil(2011,5,2), :estimated_end_date => 2.months.from_now.to_date,
                     :estimated_duration => 4, :estimated_duration_unit => Duration::WEEK)
pr.update_attributes(:status => Project::Status::IN_DEV, :updated_by => pap.id)

Project.all.each { |pr| pr.update_attribute(:description, Faker::Lorem.sentence) }

# On course projects
# 4.upto(10) do |i|
#   project = Factory(:project, :started_on => i.months.ago.to_date)
#   2.times do 
#     stage = rand(Conf.stages.length) while stage.to_i.zero?
#     status = rand(Conf.statuses.length) while status.to_i.zero?
#     Factory(:event, :stage => stage, :status => status, :project => project) 
#   end
#   Factory(:comment, :commentable => project.events.first)
# end

# Pending projects
# 6.upto(9) { |i|
#   project = Factory(:project, :estimated_start_date => i.days.from_now.to_date)
# }

# Not started projects
# 3.upto(6) { |i|
#   project = Factory(:project, :estimated_start_date => i.days.ago.to_date)
# }

# Not finished projects
# 1.upto(4) do |i|
#   project = Factory(:project, :estimated_end_date => i.weeks.ago.to_date)
#   2.times { 
#     Factory(:task, :author => gbe, :owner => mpa, :project => project) 
#   }
#   Factory(:comment, :commentable => project.tasks.first)
# end
