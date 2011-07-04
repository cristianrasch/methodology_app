BusinessTime::Config.load("#{Rails.root}/config/business_time.yml")

# or you can configure it manually:  look at me!  I'm Tim Ferris!
#  BusinessTime.Config.beginning_of_workday = "10:00 am"
#  BusinessTime.Comfig.end_of_workday = "11:30 am"
#  BusinessTime.config.holidays << Date.parse("August 4th, 2010")

# BusinessTime::Config.holidays += Holiday.this_year.map(&:date) if Holiday.table_exists?

unless Rails.env.test?
  Sequel.quote_identifiers = false
  db = Sequel.informix(Conf.ifx['db'], :user => Conf.ifx['user'], :password => Conf.ifx['passwd'])
  BusinessTime::Config.holidays += db[:feriados].filter(['tipoferiado = ?', 1]).filter(['year(fecha) = ?', Date.today.year]).all.map { |holiday| holiday[:fecha] }
end

# require 'informix'

# arr = Informix.connect(Conf.ifx['db'], Conf.ifx['user'], Conf.ifx['passwd']) do |db|
#   db.cursor('select fecha from feriados where year(fecha) = year(today)') do |cur|
#     cur.open
#     cur.fetch_all
#   end
# end
# BusinessTime::Config.holidays += arr.flatten
