# config/initializers/session_store.rb

Rails.application.config.session_store :cookie_store, key: "_wallet_system_session", expire_after: 14.days
