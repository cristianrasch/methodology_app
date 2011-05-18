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
# Holiday.create!(:name => "Año Nuevo", :date => Date.civil(2011,1,1))
# Holiday.create!(:name => "Carnaval", :date => Date.civil(2011,3,7))
# Holiday.create!(:name => "Carnaval", :date => Date.civil(2011,3,8))
# Holiday.create!(:name => "Día nacional de la Memoria por la verdad y la Justicia", :date => Date.civil(2011,3,24))
# Holiday.create!(:name => "Feriado puente turístico", :date => Date.civil(2011,3,25))
# Holiday.create!(:name => "Día del Veterano y de los Caídos en la Guerra de Malvinas", :date => Date.civil(2011,4,2))
# Holiday.create!(:name => "Jueves Santo Festividad Cristiana", :date => Date.civil(2011,4,21))
# Holiday.create!(:name => "Viernes Santo Festividad Cristiana", :date => Date.civil(2011,4,22))
# Holiday.create!(:name => "Día del Trabajador", :date => Date.civil(2011,5,1))
# Holiday.create!(:name => "Primer Gobierno Patrio", :date => Date.civil(2011,5,25))
# Holiday.create!(:name => "Día de la Bandera", :date => Date.civil(2011,6,20))
# Holiday.create!(:name => "Día de la Independencia", :date => Date.civil(2011,7,9))
# Holiday.create!(:name => "Día del Libertador José de San Martín", :date => Date.civil(2011,8,22))
# Holiday.create!(:name => "Día del Respeto a la Diversidad Cultural", :date => Date.civil(2011,10,10))
# Holiday.create!(:name => "Día de la Soberanía Nacional", :date => Date.civil(2011,11,28))
# Holiday.create!(:name => "Inmaculada Concepción de María", :date => Date.civil(2011,12,8))
# Holiday.create!(:name => "Feriado puente turístico", :date => Date.civil(2011,12,9))
# Holiday.create!(:name => "Navidad", :date => Date.civil(2011,12,25))

# org units

OrgUnit.create!(:text => 'Presidencia')
OrgUnit.create!(:text => 'Coordinación Servicios Profesionales')
srvs_prof = OrgUnit.create!(:text => 'Servicios Profesionales')
OrgUnit.create!(:text => 'Turismo', :parent_id => srvs_prof.id)
OrgUnit.create!(:text => 'Inscripciones y Publicaciones', :parent_id => srvs_prof.id)
OrgUnit.create!(:text => 'Subsidios, Seguro de Vida y Convenios', :parent_id => srvs_prof.id)
OrgUnit.create!(:text => 'Administración de Productos', :parent_id => srvs_prof.id)
OrgUnit.create!(:text => 'Marketing')
OrgUnit.create!(:text => 'Consejito')
OrgUnit.create!(:text => 'EDICON')
matric = OrgUnit.create!(:text => 'Legalizaciones, Matrículas y Control')
OrgUnit.create!(:text => 'Legalizaciones', :parent_id => matric.id)
OrgUnit.create!(:text => 'Matrículas', :parent_id => matric.id)
OrgUnit.create!(:text => 'Vigilancia Profesional', :parent_id => matric.id)
salud = OrgUnit.create!(:text => 'Consejo Salud')
OrgUnit.create!(:text => 'Sistema SIMECO', :parent_id => salud.id)
OrgUnit.create!(:text => 'SAP', :parent_id => salud.id)
OrgUnit.create!(:text => 'Centro Médico', :parent_id => salud.id)
OrgUnit.create!(:text => 'Coordinación Temas Académicos')
tecnica = OrgUnit.create!(:text => 'Técnica')
OrgUnit.create!(:text => 'Asesores', :parent_id => tecnica.id)
OrgUnit.create!(:text => 'Comisiones', :parent_id => tecnica.id)
OrgUnit.create!(:text => 'Congresos y Eventos', :parent_id => tecnica.id)
OrgUnit.create!(:text => 'Administración de RCyT', :parent_id => tecnica.id)
OrgUnit.create!(:text => 'Sindicatura Concursal', :parent_id => tecnica.id)
OrgUnit.create!(:text => 'Escuela de Educación Continuada')
OrgUnit.create!(:text => 'Instituto de Ciencias Económicas')
OrgUnit.create!(:text => 'Centro de Información Bibliográfica')
OrgUnit.create!(:text => 'Centro de Mediación')
admin = OrgUnit.create!(:text => 'Administración')
OrgUnit.create!(:text => 'Contaduría', :parent_id => admin.id)
OrgUnit.create!(:text => 'Tesorería', :parent_id => admin.id)
OrgUnit.create!(:text => 'Correspondencia', :parent_id => admin.id)
OrgUnit.create!(:text => 'Compras', :parent_id => admin.id)
OrgUnit.create!(:text => 'Mesa de Entradas', :parent_id => admin.id)
rrhh = OrgUnit.create!(:text => 'RRHH y Servicios')
OrgUnit.create!(:text => 'Administración de RRHH', :parent_id => rrhh.id)
OrgUnit.create!(:text => 'Vigilancia', :parent_id => rrhh.id)
OrgUnit.create!(:text => 'Servicios Generales', :parent_id => rrhh.id)
OrgUnit.create!(:text => 'Servicio de empleo', :parent_id => rrhh.id)
OrgUnit.create!(:text => 'Orientación Laboral', :parent_id => rrhh.id)
it = OrgUnit.create!(:text => 'Sistemas')
OrgUnit.create!(:text => 'Desarrollo', :parent_id => it.id)
OrgUnit.create!(:text => 'Base de Datos', :parent_id => it.id)
OrgUnit.create!(:text => 'Redes e Internet', :parent_id => it.id)
OrgUnit.create!(:text => 'Trivia', :parent_id => it.id)
OrgUnit.create!(:text => 'Auditoria y Control de Gestión')
OrgUnit.create!(:text => 'Relaciones Públicas')
rel = OrgUnit.create!(:text => 'Relaciones Institucionales')
OrgUnit.create!(:text => 'Sec. de Mesa y Consejo Directivo', :parent_id => rel.id)
OrgUnit.create!(:text => 'Desarrollo Profesional', :parent_id => rel.id)
OrgUnit.create!(:text => 'Seguridad Informática')
OrgUnit.create!(:text => 'Asuntos Legales')
OrgUnit.create!(:text => 'Tribunal Arbitral')
OrgUnit.create!(:text => 'Organización y Métodos')
OrgUnit.create!(:text => 'Gestión de la Calidad')

# devs
gbe = User.find_by_username('gbe')
crr = User.find_by_username('crr')
fol = User.find_by_username('fol')
mpa = User.find_by_username('mpa')
ljg = User.find_by_username('ljg')
gar = User.find_by_username('gar')
mev = User.find_by_username('mev')

# end-users
est = User.find_by_username('est')
eod = User.find_by_username('eod')
nss = User.find_by_username('nss')
crg = User.find_by_username('crg')
sre = User.find_by_username('sre')

[gbe,crr,fol,mpa,ljg,gar,mev,est,eod,nss,crg,sre].each {|user|
  user.update_attribute(:email, "#{user.username}123@consejo.org.ar")
}

[gbe, crr, fol, mpa, ljg, gar, mev, est, eod, ]

Factory(:project, :description => 'Query inscriptos comicios', :klass => Project::Klass::PROC, 
        :dev => gbe, :owner => est)
Factory(:project, :description => 'Citi Compras', :dev => crr, :owner => eod)
Factory(:project, :description => 'Turnero Documentos - Agregar Feriado', :klass => Project::Klass::PROC, 
        :dev => fol, :owner => nss)
Factory(:project, :description => 'SUB Interfase bejerman integra. correc de registro',
        :klass => Project::Klass::PROC, :dev => mpa, :owner => crg)
Factory(:project, :description => 'Restaurar Backup base de datos Proezas',
        :klass => Project::Klass::PROC, :dev => ljg, :owner => sre)
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
