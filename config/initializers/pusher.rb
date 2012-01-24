require 'pusher'

pusher = Rails.application.config.settings.pusher
Pusher.app_id, Pusher.key, Pusher.secret = pusher.values_at(:app_id, :key, :secret) if pusher


