Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :bcrypt
  manager.failure_app = UserSessionsController
end

# Declare your strategies here
#Warden::Strategies.add(:my_strategy) do
#  def authenticate!
#    # do stuff
#  end
#end

# Setup Session Serialization
Warden::Manager.serialize_into_session{ |user| user.id }
Warden::Manager.serialize_from_session{ |id| User.first(:id => id) }

Warden::Strategies.add(:bcrypt) do
  def valid?
    params["user_session"]["login"] || params["user_session"]["password"]
  end

  def authenticate!
    return fail! unless user = User.find_by_login(params["user_session"]["login"])

    if user.crypted_password == "#{params["user_session"]["password"]}"
      success!(user)
    else
      #What is this errors?
      errors.add(:login, "Username or Password incorrect")
      fail!
    end
  end
end

Warden::Manager.after_authentication do |user, auth, opts|
  old_current = user.current_login_at
  old_current ||= user.current_login_at = DateTime.now
  user.last_login_at = old_current
  user.current_login_at = DateTime.now
  user.login_count = 0 if user.login_count.nil?
  user.login_count += 1
  user.save
end
