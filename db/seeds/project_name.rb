pr0 = ProjectName.find_or_create_by_text("AFIP Reg Especiales")
pr1 = ProjectName.find_or_create_by_text("Compras", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("AFIP Reg Especiales")
pr1 = ProjectName.find_or_create_by_text("Registraciones electr¢nica", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("AFIP Reg Especiales")
pr1 = ProjectName.find_or_create_by_text("Venta  ", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Asesores")
pr1 = ProjectName.find_or_create_by_text("Registro de Consultas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Asesores")
pr1 = ProjectName.find_or_create_by_text("Reserva de turnos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Auxiliares de Justicia")
pr1 = ProjectName.find_or_create_by_text("Coadministradores", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Auxiliares de Justicia")
pr1 = ProjectName.find_or_create_by_text("Peritos comerciales", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Auxiliares de Justicia")
pr1 = ProjectName.find_or_create_by_text("Síndicos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Bancos")
pr0 = ProjectName.find_or_create_by_text("Campañas Telefónicas")
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Cobranzas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Inscripción", :parent_id => pr0)
pr2 = ProjectName.create(:text => "General", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Inscripción ", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Ciclos Tributarios WEB", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Planificación de cursos", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administración", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Capacitación")
pr1 = ProjectName.find_or_create_by_text("Planificación de cursos", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Consulta próximos cursos", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Cobranzas")
pr1 = ProjectName.find_or_create_by_text("Caja", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Cajero", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Cobranzas")
pr1 = ProjectName.find_or_create_by_text("Caja", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Tesoreria", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Cobranzas")
pr1 = ProjectName.find_or_create_by_text("Caja", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Administracion", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Cobranzas ")
pr1 = ProjectName.find_or_create_by_text("Caja", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Interfase Stock Bejerman", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Comisiones")
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("18ø Congreso Nacional", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Inscripción provincias", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("18ø Congreso Nacional", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Inscripción provincias", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Cobranza", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Inscripción", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Internet", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Inscripción", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Mostrador", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Congresos")
pr1 = ProjectName.find_or_create_by_text("Planificación", :parent_id => pr0)
pr2 = ProjectName.create(:text => " ", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Debito Automatico")
pr1 = ProjectName.find_or_create_by_text("Adhesion", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Debito Automatico")
pr1 = ProjectName.find_or_create_by_text("Consultas/Listados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Debito Automatico")
pr1 = ProjectName.find_or_create_by_text("Envios y rechazos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("AFIP", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Cobranzas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Consultas / Listados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Debito Automatico", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Estadisticas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Facturacion DEP-DRE", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Tareas Previas", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Facturacion DEP-DRE", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Facturacion", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Facturacion DEP-DRE", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Impresion de facturas", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Morosos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Plan de Pagos / Facilidades", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Derecho de Ejercicio")
pr1 = ProjectName.find_or_create_by_text("Recaudacion Bancos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Edicon")
pr1 = ProjectName.find_or_create_by_text("Complementos Profesionales", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Estudiantes - Registro")
pr1 = ProjectName.find_or_create_by_text("Solicitud por Internet", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Facturación Unificada")
pr1 = ProjectName.find_or_create_by_text("Consultas/transferencias", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Facturación Unificada")
pr1 = ProjectName.find_or_create_by_text("Generación de FC, NCR y ND", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Facturación Unificada")
pr1 = ProjectName.find_or_create_by_text("Venta de productos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Foros")
pr1 = ProjectName.find_or_create_by_text("Foro WEB", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Foros")
pr1 = ProjectName.find_or_create_by_text("Inscripción", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Honorarios M¡nimos")
pr0 = ProjectName.find_or_create_by_text("Internet")
pr1 = ProjectName.find_or_create_by_text("Adhesion", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Internet")
pr1 = ProjectName.find_or_create_by_text("Cobranzas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Internet")
pr1 = ProjectName.find_or_create_by_text("Cuenta Corriente", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Internet")
pr1 = ProjectName.find_or_create_by_text("Facturación", :parent_id => pr0)
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
pr1 = ProjectName.find_or_create_by_text("Baja Rehabilitación", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Base de Datos de Calles", :parent_id => pr0)
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
pr1 = ProjectName.find_or_create_by_text("Consulta de datos personales", :parent_id => pr0)
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
pr1 = ProjectName.find_or_create_by_text("Listados y Estadísticas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Nuevos matriculados", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Nuevo folio", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Nuevos matriculados", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Registro de firmas de Intranet", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Matriculados")
pr1 = ProjectName.find_or_create_by_text("Referentes y referidos", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Mesa de Entrada")
pr0 = ProjectName.find_or_create_by_text("Nuevos Matriculados")
pr1 = ProjectName.find_or_create_by_text("Encuesta", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Nuevos Matriculados")
pr1 = ProjectName.find_or_create_by_text("Profesionales", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Nuevos Matriculados")
pr1 = ProjectName.find_or_create_by_text("Registros Especiales", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Personal")
pr0 = ProjectName.find_or_create_by_text("RCyT")
pr1 = ProjectName.find_or_create_by_text("Actualidad Tributaria", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("RCyT")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("RCyT")
pr1 = ProjectName.find_or_create_by_text("Inscripcion x Internet", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("RCyT")
pr1 = ProjectName.find_or_create_by_text("Videos arancelados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Resoluciones MD")
pr0 = ProjectName.find_or_create_by_text("Seguro de Vida")
pr0 = ProjectName.find_or_create_by_text("SFAP")
pr1 = ProjectName.find_or_create_by_text("Exportación a Federación", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("SFAP")
pr1 = ProjectName.find_or_create_by_text("Listado y Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sicore")
pr0 = ProjectName.find_or_create_by_text("Sistema Contable")
pr0 = ProjectName.find_or_create_by_text("Sistema Medico")
pr1 = ProjectName.find_or_create_by_text("Tarjeta Integrar", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Administrador de Mails", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Componentes comunes, utilidades", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Edición de parámetros", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Encuestas genericas x Internet", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("gesti¢n de emails", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Internet", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Webmail front-end", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Intranet", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Menú Intranet", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Intranet", :parent_id => pr0)
pr2 = ProjectName.create(:text => "Sistemas, Usuarios y Roles", :parent_id => pr1)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Login de Matriculados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Mantenimiento de tablas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Pantalla con env¡o de email", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Pantalla de confirmación", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Pantalla de ingreso tarjeta de crédito", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Sistemas")
pr1 = ProjectName.find_or_create_by_text("Reserva de Turnos de la sala de Informática", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Subsidios")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Subsidios")
pr1 = ProjectName.find_or_create_by_text("Consultas/listados", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Subsidios")
pr1 = ProjectName.find_or_create_by_text("Devengamiento", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Subsidios")
pr1 = ProjectName.find_or_create_by_text("Interfase Bejerman", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Tarjetas Consetel")
pr1 = ProjectName.find_or_create_by_text("Administración", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Tarjetas Consetel")
pr1 = ProjectName.find_or_create_by_text("Cobranzas", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Tarjetas Consetel")
pr1 = ProjectName.find_or_create_by_text("Transferencia", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Tribunal  de Etica Profesional")
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Adhesion", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Bolet¡n", :parent_id => pr0)
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
pr1 = ProjectName.find_or_create_by_text("Historial", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Login", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Noticias", :parent_id => pr0)
pr0 = ProjectName.find_or_create_by_text("Trivia")
pr1 = ProjectName.find_or_create_by_text("Pases libres", :parent_id => pr0)
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
