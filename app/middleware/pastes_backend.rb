require 'faye/websocket'
require 'thread'
require 'json'
require 'erb'

module LiveUpdate
  class PastesBackend
    KEEPALIVE_TIME = 15 # in seconds
    CHANNEL        = "paste-updates"
    APP_CONFIG = YAML::load_file(Rails.root + "config/config.yml")[Rails.env]

    def initialize(app)
      @app     = app
      @clients = []
      
      uri = URI.parse(APP_CONFIG['redis_url'])

      Rails.application.pastes_publisher = self

      @redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
      Thread.new do
        redis_sub = Redis.new(host: uri.host, port: uri.port, password: uri.password)
        redis_sub.subscribe(CHANNEL) do |on|
          on.message do |channel, msg|
            @clients.each do |ws|
              ws.send(msg)
            end
          end
        end
      end
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
        ws.on :open do |event|
          p [:open, ws.object_id]
          @clients << ws
        end

        ws.on :message do |event|

          p [:message, event.data]
          @redis.publish(CHANNEL, sanitize(event.data))
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          @clients.delete(ws)
          ws = nil
        end

        # Return async Rack response
        ws.rack_response

      else
        @app.call(env)
      end
    end

    def send_json_msg(msg)
      @redis.publish(CHANNEL, sanitize(msg))
    end

    private
    def sanitize(message)
      json = JSON.parse(message)
      json.each {|key, value| json[key] = ERB::Util.html_escape(value) }
      JSON.generate(json)
    end
  end
end