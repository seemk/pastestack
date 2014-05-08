require 'test_helper'
require 'rails/performance_test_help'
require 'securerandom'
require 'celluloid/autostart'
require 'date'

class Requester
    include Celluloid

    def initialize(request)
        @request = request
    end
    def execute
        @request.call
    end
end

class PastePerformanceTest < ActionDispatch::PerformanceTest
  self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
                            output: 'tmp/performance', formats: [:flat] }
  
  def setup
    Rails.logger.level = ActiveSupport::Logger::DEBUG
    @rand_content = SecureRandom.hex(1024).freeze
    @searchable_pastes = (1..1000).map { |i| FactoryGirl.create(:paste,
                                                               :title => SecureRandom.hex(10)) }
  end

  def generate_paste(title = '')
    { content: @rand_content, exposure: 1,
      expiration: Time.now.utc,
      title: title }
  end

  # Celluloid uses an internal thread pool for futures
  # which clogs up the database by leaking connections.
  # TODO: Find an ActiveRecord friendly concurrent way
  # to spam the database.
  def exec_concurrent_requests(request, count = 20)
    futures = Array.new(count) { Celluloid::Future.new {
            request.call
        }
    }
    futures.each { |f| f.value }
  end

  def exec_requests(request, count = 20)
    count.times { request.call }
  end

  test "homepage" do
    request = lambda { get '/' }
    exec_requests(request)
  end

  test "random_title_paste_creation" do
    request = lambda {
        paste = generate_paste(SecureRandom.hex(10))
        post '/pastes', paste: paste
    }
    # See the TODO
    #exec_concurrent_requests(request)
    exec_requests(request)
  end

  test "paste_creation" do
    request = lambda {
        post '/pastes', paste: generate_paste
    }
    # See the TODO
    #exec_concurrent_requests(request)
    exec_requests(request)
  end

end
