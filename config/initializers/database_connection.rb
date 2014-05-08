Rails.application.config.after_initialize do
    ActiveRecord::Base.connection_pool.disconnect!

    ActiveSupport.on_load(:active_record) do
        config = ActiveRecord::Base.configurations[Rails.env] ||
            Rails.application.config.database_configuration[Rails.env]
        config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10
        config['pool'] = ENV['MAX_THREADS']
        ActiveRecord::Base.establish_connection(config)
    end
end
