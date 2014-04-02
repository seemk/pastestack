require 'pastes_backend'

 Rails.application.config.middleware.use LiveUpdate::PastesBackend
