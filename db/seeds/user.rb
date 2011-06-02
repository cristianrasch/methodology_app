# devs
mpa = User.find_by_username('mpa')
gbe = User.find_by_username('gbe')
gbe.update_attribute(:name, 'Belingueres, Gabriel')
crr = User.find_by_username('crr')
crr.update_attribute(:name, 'Rasch, Cristian Adrián')
fol = User.find_by_username('fol')
fol.update_attribute(:name, 'Oliveri, Federico')
pap = User.find_by_username('pap')
pap.update_attribute(:name, 'Pinto, Pablo Ariel')
User.find_by_username('adf').update_attribute(:name, 'Fournier, Andrés David')
User.find_by_username('ljg').update_attribute(:name, 'Gauna, Leandro José')
User.find_by_username('sva').update_attribute(:name, 'Valentini, Sergio')

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

User.update_all({:potential_owner => true}, :username => Conf.potential_owners.split(','))
