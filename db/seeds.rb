# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# production users import
User.import

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
mpa = User.find_by_username('mpa')
gbe = User.find_by_username('gbe')
crr = User.find_by_username('crr')
fol = User.find_by_username('fol')
pap = User.find_by_username('pap')

# end-users
crg = User.find_by_username('crg')
est = User.find_by_username('est')
eod = User.find_by_username('eod')
nss = User.find_by_username('nss')
tks = User.find_by_username('tks')
gig = User.find_by_username('gig')
gem = User.find_by_username('gem')

[gbe,mpa,est,crg,crr,eod,fol,nss,tks,gig,pap,gem].each {|user|
  unless user.email
    name = user.name
    comma = name.index(',')
    surname = name[0, comma].downcase
    letter = name[comma+2, name.length-comma-2].first.downcase
    user.update_attribute(:email, "#{letter}#{surname}@consejo.org.ar")
  end
}

# project names
pr0 = ProjectName.find_or_create_by_text("Asesoramiento Profesional")
pr1 = ProjectName.find_or_create_by_text("Registro de Consultas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Auxiliares de la justicia")
pr1 = ProjectName.find_or_create_by_text("Peritos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Auxiliares de la justicia")
pr1 = ProjectName.find_or_create_by_text("Síndicos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Bancos")
pr1 = ProjectName.find_or_create_by_text("Administracion (ABM)", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Bancos")
pr1 = ProjectName.find_or_create_by_text("Ingreso/Transmision de mvtos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Cobranzas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Inscripción", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administración", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Inscripción", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Consultas/listados", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Inscripción ", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Ciclos Tributarios WEB", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Planificación de cursos", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administración", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Planificación de cursos", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Consultas/listados", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Planificación de cursos", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Consulta próximos cursos", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Cobranzas")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Cobranzas")
pr1 = ProjectName.find_or_create_by_text("Caja", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Cobranzas")
pr1 = ProjectName.find_or_create_by_text("Tesorería", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Comisiones")
pr1 = ProjectName.find_or_create_by_text("Administracion", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Comisiones")
pr1 = ProjectName.find_or_create_by_text("Consultas/listados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("18 Congreso", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Inscripción CABA", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("18 Congreso", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Inscripción provincias", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Cobranza", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Inscripción", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administración", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Inscripción", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Consultas/listados/transferencias", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Inscripción por Internet", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Planificación", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administración", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Planificación", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Consultas/listados/transferencias", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Facturación Unificada")
pr1 = ProjectName.find_or_create_by_text("Consultas/transferencias", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Facturación Unificada")
pr1 = ProjectName.find_or_create_by_text("Generación FC, NCR, ND", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Facturación Unificada")
pr1 = ProjectName.find_or_create_by_text("Venta de productos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Foros")
pr1 = ProjectName.find_or_create_by_text("Foro WEB", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Foros")
pr1 = ProjectName.find_or_create_by_text("Inscripción a foros", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Honorarios Mínimos")
pr0 = ProjectName.find_or_create_by_text("Internet")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Internet")
pr1 = ProjectName.find_or_create_by_text("Cobranzas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Internet")
pr1 = ProjectName.find_or_create_by_text("Facturación", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Internet")
pr1 = ProjectName.find_or_create_by_text("Suscripción", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("Cobranzas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("Cuenta Corriente", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administración", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("Cuenta Corriente", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Consulta, listados y estadísticas", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("Cuenta Corriente", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Facturación", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("DGR", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("F780", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Presentación", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("F780", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Transferencia AFIP", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("F780", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Convenio", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("F780", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administración", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("Gestor tributario", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("Informe Confidencial", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("Listados, Estadísticas y Consultas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Legalizaciones")
pr1 = ProjectName.find_or_create_by_text("Registración y Verificación", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Baja y Rehabilitación", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administracion (ABM)", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Base de Datos de Calles", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Consulta a la Base", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Base de Datos de Calles", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Altas y Modificaciones a la Base", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Cambio de domicilio", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Carga de CBUs", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Certificados", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administrador de consorcio", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Certificados", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Constancia de estampilla", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Certificados", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Inscripción, sanción y libre deuda", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Consultas, Listados, Estadísticas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Credencial profesional", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Listado y consulta ", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Credencial profesional", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Importación de imágenes de puestos offline", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Credencial profesional", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Emisión", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Impresión de Notas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Referentes y referidos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Mesa de Entrada")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Mesa de Entrada")
pr1 = ProjectName.find_or_create_by_text("Consultas/listados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Nuevos Matriculados")
pr1 = ProjectName.find_or_create_by_text("DEP", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Nuevos Matriculados")
pr1 = ProjectName.find_or_create_by_text("Expedientes", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Nuevos Matriculados")
pr1 = ProjectName.find_or_create_by_text("Folio", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Nuevos Matriculados")
pr1 = ProjectName.find_or_create_by_text("Resoluciones", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Personal")
pr1 = ProjectName.find_or_create_by_text("Administración de datos y áreas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("RCyT")
pr1 = ProjectName.find_or_create_by_text("Actualidad Tributaria", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("RCyT")
pr1 = ProjectName.find_or_create_by_text("Administración de RCyT", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("RCyT")
pr1 = ProjectName.find_or_create_by_text("Inscripcion x Internet", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("RCyT")
pr1 = ProjectName.find_or_create_by_text("Videos arancelados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Registro de estudiantes")
pr1 = ProjectName.find_or_create_by_text("Inscripción", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Reserva de turnos")
pr0 = ProjectName.find_or_create_by_text("Resoluciones de Mesa Directiva")
pr1 = ProjectName.find_or_create_by_text("Administracion (ABM)", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Resoluciones de Mesa Directiva")
pr1 = ProjectName.find_or_create_by_text("Consultas/Listados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Seguro de Vida")
pr1 = ProjectName.find_or_create_by_text("Facturación", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("SFAP")
pr1 = ProjectName.find_or_create_by_text("Exportación a Federación", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("SFAP")
pr1 = ProjectName.find_or_create_by_text("Listado y Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistema Contable")
pr1 = ProjectName.find_or_create_by_text("Interfase", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistema Contable")
pr1 = ProjectName.find_or_create_by_text("Plan de cuentas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistema Medico")
pr1 = ProjectName.find_or_create_by_text("Tarjeta Integrar", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Administrador de Mails", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administración", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Encuestas genericas x Internet", :parent_id => pr0)
pr2 = ProjectName.create(:text => "encustas", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("gestión de emails", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Antispam", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("gestión de emails", :parent_id => pr0)
pr2 = ProjectName.create(:text => "CambioEmailPassword", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Internet", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Webmail front-end", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Intranet", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Archivos protegidos de Intranet", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Intranet", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Consultas a la base de datos", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Intranet", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Menú Intranet", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Login de Matriculados", :parent_id => pr0)
pr2 = ProjectName.create(:text => "login", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Pantalla con envío de email", :parent_id => pr0)
pr2 = ProjectName.create(:text => "enviaEmailGenerico", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Pantalla de confirmación", :parent_id => pr0)
pr2 = ProjectName.create(:text => "confirmaClick", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Pantalla de ingreso tarjeta de crédito", :parent_id => pr0)
pr2 = ProjectName.create(:text => "tarjeta", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("procesos mantenimiento de tablas", :parent_id => pr0)
pr2 = ProjectName.create(:text => "BorrarEmailUnknownDaemon", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("procesos mantenimiento de tablas", :parent_id => pr0)
pr2 = ProjectName.create(:text => "BorraEnvioMailDaemon", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("procesos mantenimiento de tablas", :parent_id => pr0)
pr2 = ProjectName.create(:text => "SessionEraser", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Subsidios")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Subsidios")
pr1 = ProjectName.find_or_create_by_text("Consultas/listados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Subsidos")
pr1 = ProjectName.find_or_create_by_text("Devengamiento", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Subsidos")
pr1 = ProjectName.find_or_create_by_text("Interfase Bejerman", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Tarjetas Consetel")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Tarjetas Consetel")
pr1 = ProjectName.find_or_create_by_text("Cobranzas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Tarjetas Consetel")
pr1 = ProjectName.find_or_create_by_text("Transferencia", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Tribunal  de Etica Profesional")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Administracion (ABM)", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Boletín", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Calendario impositivo", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Cobranzas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Consultas/Listados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Cuenta Corriente", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Débito Automático", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Encuesta", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Estadísticas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Facturación", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Historial de Trivia", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Login", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Pases libres", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Suscripción", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Trivia CD", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Turismo")
pr1 = ProjectName.find_or_create_by_text("Listas de casamiento", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Ventas varias")
pr1 = ProjectName.find_or_create_by_text("Cena", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Ventas varias")
pr1 = ProjectName.find_or_create_by_text("Día de campo", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Ventas varias")
pr1 = ProjectName.find_or_create_by_text("Truco", :parent_id => pr0)

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

