class Paste < ActiveRecord::Base
    belongs_to :user
    before_validation :random_title
    before_save :convert_time
    default_scope -> { order('created_at DESC') }
    validates :content, presence: true
    validates :title, uniqueness: { case_sensitive: false }
    validates :expiration, presence: true

    after_save :notify_publisher

    def to_param
        title
    end

    def self.find(input)
        find_by_title(input)
    end

private
    def random_title
        self.title = (0...10).map { ('a'..'z').to_a[rand(26)] }.join if self.title.empty?
    end

    def convert_time
        self.expiration = self.expiration.to_datetime
    end

    def notify_publisher
        publisher = Rails.application.pastes_publisher
        publisher.send_json_msg(self.to_json) unless publisher.nil?
    end
end
