# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# import production users
User.import

# 2011 holidays
Holiday.create!(:name => "Año Nuevo", :date => Date.civil(2011,1,1))
Holiday.create!(:name => "Carnaval", :date => Date.civil(2011,3,7))
Holiday.create!(:name => "Carnaval", :date => Date.civil(2011,3,8))
Holiday.create!(:name => "Día nacional de la Memoria por la verdad y la Justicia", :date => Date.civil(2011,3,24))
Holiday.create!(:name => "Feriado puente turístico", :date => Date.civil(2011,3,25))
Holiday.create!(:name => "Día del Veterano y de los Caídos en la Guerra de Malvinas", :date => Date.civil(2011,4,2))
Holiday.create!(:name => "Jueves Santo Festividad Cristiana", :date => Date.civil(2011,4,21))
Holiday.create!(:name => "Viernes Santo Festividad Cristiana", :date => Date.civil(2011,4,22))
Holiday.create!(:name => "Día del Trabajador", :date => Date.civil(2011,5,1))
Holiday.create!(:name => "Primer Gobierno Patrio", :date => Date.civil(2011,5,25))
Holiday.create!(:name => "Día de la Bandera", :date => Date.civil(2011,6,20))
Holiday.create!(:name => "Día de la Independencia", :date => Date.civil(2011,7,9))
Holiday.create!(:name => "Día del Libertador José de San Martín", :date => Date.civil(2011,8,22))
Holiday.create!(:name => "Día del Respeto a la Diversidad Cultural", :date => Date.civil(2011,10,10))
Holiday.create!(:name => "Día de la Soberanía Nacional", :date => Date.civil(2011,11,28))
Holiday.create!(:name => "Inmaculada Concepción de María", :date => Date.civil(2011,12,8))
Holiday.create!(:name => "Feriado puente turístico", :date => Date.civil(2011,12,9))
Holiday.create!(:name => "Navidad", :date => Date.civil(2011,12,25))

mpa = User.find_by_username('mpa')
leg = Factory(:project, :description => 'Inscripc Simplificada Matriculados', :klass => Project::Klass::IMPR, 
              :dev => mpa)
Factory(:event, :project => leg)

ljg = User.find_by_username('ljg')
priv = Factory(:project, :description => 'Restauración del S.O en Acuario y base de datos',
               :klass => Project::Klass::PROC, :dev => ljg,
               :started_on => 2.months.ago.to_date, :ended_on => 1.week.ago.to_date, 
               :estimated_duration => 8, :compl_perc => 100)
Factory(:event, :project => priv, :stage => Conf.stages.keys.last, :status => Conf.statuses.keys.last)              
      
clb = User.find_by_username('clb')
ifx = Factory(:project, :description => 'Instalación de nueva base TEST', :klass => Project::Klass::IMPR, :dev => clb)
Factory(:event, :project => ifx)

dda = User.find_by_username('dda')
tec = Factory(:project, :description => 'Reemplazo firma Jaunarena a Luchetti',
              :klass => Project::Klass::IMPR, :dev => dda,
              :started_on => 1.month.ago.to_date, :ended_on => 3.weeks.ago.to_date, 
              :estimated_duration => 5, :compl_perc => 100)
Factory(:event, :project => tec, :stage => Conf.stages.keys.last, :status => Conf.statuses.keys.last)

pap = User.find_by_username('pap')
f780 = Factory(:project, :description => 'Modif Contrato Adhesión Datos Pers',
               :klass => Project::Klass::IMPR, :dev => pap,
               :started_on => 2.weeks.ago.to_date, :ended_on => Date.yesterday, 
               :estimated_duration => 12, :compl_perc => 100)
Factory(:event, :project => f780, :stage => Conf.stages.keys.last, :status => Conf.statuses.keys.last)

gbe = User.find_by_username('gbe')
adm = Factory(:project, :description => 'Carga inicial CBU',
              :klass => Project::Klass::PROC, :dev => gbe,
              :started_on => 3.weeks.ago.to_date, 
              :estimated_duration => 40, :compl_perc => 10)
Factory(:event, :project => adm)

rel = Factory(:project, :description => 'Cena cubierto Graduados',
              :klass => Project::Klass::IMPR, :dev => gbe,
              :started_on => 1.week.ago.to_date, 
              :estimated_duration => 25, :compl_perc => 50)
Factory(:event, :project => rel, :status => Conf.statuses.keys[2])

adf = User.find_by_username('adf')
tiv = Factory(:project,
              :description => 'Restaurar la base de datos interna del sistema TIVOLI por corrupción de la misma',
              :klass => Project::Klass::IMPR, :dev => adf,
              :started_on => Date.yesterday, :ended_on => Date.yesterday, 
              :estimated_duration => 4, :compl_perc => 100)
Factory(:event, :project => f780, :stage => Conf.stages.keys.last, :status => Conf.statuses.keys.last)

# On course projects
4.upto(10) do |i|
  project = Factory(:project, :started_on => i.months.ago.to_date)
  2.times do 
    stage = rand(Conf.stages.length) while stage.to_i.zero?
    status = rand(Conf.statuses.length) while status.to_i.zero?
    Factory(:event, :stage => stage, :status => status, :project => project) 
  end
  Factory(:comment, :commentable => project.events.first)
end

# Pending projects
6.upto(9) { |i|
  project = Factory(:project, :estimated_start_date => i.days.from_now.to_date)
}

# Not started projects
3.upto(6) { |i|
  project = Factory(:project, :estimated_start_date => i.days.ago.to_date)
}

# Not finished projects
1.upto(4) do |i|
  project = Factory(:project, :estimated_end_date => i.weeks.ago.to_date)
  2.times { 
    Factory(:task, :author => gbe, :owner => mpa, :project => project) 
  }
  Factory(:comment, :commentable => project.tasks.first)
end