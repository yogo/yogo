# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_3ebe990f_2272_4375_b373_ed2c3044142d_session',
  :secret      => 'df853df6b32692bd5dd95e6a2f1c8ad1d8204d2f0561e4f2dd55f564f077624806918b48bd475f73f1c1c4f5b011faea409e4a9e0413a31c245a839a627f597c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
