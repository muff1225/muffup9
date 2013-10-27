# Be sure to restart your server when you modify this file.

RailsApp::Application.config.session_store :cookie_store, key: '_rails_app_session'
# RailsApp::Application.config.session_store :redis_store, :redis_server => {:host => ENV["C4SA_SHARED_REDIS_IP"], :port => ENV["C4SA_SHARED_REDIS_PORT"], :password => ENV["C4SA_SHARED_REDIS_PASSWORD"]}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# RailsApp::Application.config.session_store :active_record_store
