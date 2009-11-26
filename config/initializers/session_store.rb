# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_simple-inbox_session',
  :secret      => 'cbaf6debaad4ab90958c194963e43ae7d4b56cf7470a1da0533a6c4e6ec512bfff094c92bf182604ac47791c1f15376b4ec15535c354f8981cb8664d1ae23fa2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
