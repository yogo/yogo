# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_yogo_session',
  :secret      => '1fc7aed66beb64f650ee80d1722c95fa3bcfc880d2ba894823f18d0b3e91b3c3641e3da6f7159958eb8e4368e72d6f632d92354fa9abd44e51f57a3fc9819d9f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
