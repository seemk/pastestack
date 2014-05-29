require 'faye/websocket'
require 'thread'
require 'json'
require 'erb'

module LiveUpdate
  class PastesBackend
    KEEPALIVE_TIME = 15 # in seconds
    CHANNEL        = "paste-updates"

    def initialize(app)
      @app     = app
      @clients = []
      
      redis_path = Rails.env.production? ? ENV['REDISCLOUD_URL'] : 'localhost:6379'
      uri = URI.parse(redis_path)

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
      begin
        @redis.publish(CHANNEL, sanitize(msg))
      rescue Redis::CommandError => err
          Rails.logger.error err
      end
    end

    private
    def sanitize(message)
      json = JSON.parse(message)
      json.each {|key, value| json[key] = ERB::Util.html_escape(value) }
      JSON.generate(json)
    end
  end
end
