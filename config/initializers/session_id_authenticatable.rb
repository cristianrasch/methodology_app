Warden::Strategies.add(:session_id_authenticatable) do 
  def valid? 
    params.has_key?('sessionID')
  end 

  def authenticate!
    resource = User.authenticate_by_session_id(params['sessionID'])
    resource ? success!(resource) : fail(:invalid)
  end 
end
