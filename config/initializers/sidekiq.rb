require 'sidekiq/cron'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://redis:6379') }
  config.queues = %w(chats messages default)

  Sidekiq::Cron::Job.load_from_hash YAML.load_file('config/sidekiq-cron.yml') if File.exist?('config/sidekiq-cron.yml')
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://redis:6379') }
end
