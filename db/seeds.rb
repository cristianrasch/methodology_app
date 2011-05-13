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

gbe = User.find_by_username('gbe')
crr = User.find_by_username('crr')
fol = User.find_by_username('fol')
mpa = User.find_by_username('mpa')
ljg = User.find_by_username('ljg')
gar = User.find_by_username('gar')
mev = User.find_by_username('mev')

Factory(:project, :description => 'Query inscriptos comicios', :klass => Project::Klass::PROC, 
        :dev => gbe, :owner => User.find_by_username('est'))
Factory(:project, :description => 'Citi Compras', :dev => crr, :owner => User.find_by_username('eod'))
Factory(:project, :description => 'Turnero Documentos - Agregar Feriado', :klass => Project::Klass::PROC, 
        :dev => fol, :owner => User.find_by_username('nss'))
Factory(:project, :description => 'SUB Interfase bejerman integra. correc de registro',
        :klass => Project::Klass::PROC, :dev => mpa, :owner => User.find_by_username('crg'))
Factory(:project, :description => 'Restaurar Backup base de datos Proezas',
        :klass => Project::Klass::PROC, :dev => ljg, :owner => User.find_by_username('sre'))
# Factory(:project, :description => 'Inscripción web autoridades comicios 2011',
#         :dev => gbe, :owner => mev)
# Factory(:project, :description => 'Encuesta Nuevo Matric - nuevos campos', :klass => Project::Klass::IMPR, 
#         :dev => fol, :owner => User.find_by_username('gig'))
# Factory(:project, :description => 'Query Trivia No logeados', :dev => gbe, :owner => mev)
# Factory(:project, :description => 'Restauración carpeta de Fileserver de SIMECO',
#         :klass => Project::Klass::PROC, :dev => ljg, :owner => gar)

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
