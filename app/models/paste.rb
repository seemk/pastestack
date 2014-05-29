class Paste < ActiveRecord::Base
    belongs_to :user
    before_save :convert_time, :null_language
    default_scope -> { order('created_at DESC') }

    validates :content, presence: true
    validates :expiration, presence: true

    before_create :generate_token, :set_title
    after_create :notify_publisher

    self.per_page = 15

    def to_param
        token
    end

    def self.find(input)
        find_by_title(input)
    end

    def private?
        self.exposure == 0
    end

    def public?
        self.exposure >= 1
    end

    def has_title?
        self.title.nil?
    end

    def language_code
        if language.nil?
            return "none"
        end
        lang = language.downcase
        sanitizations = { "c++" => "cpp" }.freeze
        if sanitizations.has_key?(lang)
            sanitizations[lang]
        else
            lang
        end
    end

private

    def null_language
        if self.language
            self.language = nil if self.language.downcase == "none"
        end
        return true
    end

    def convert_time
        self.expiration = self.expiration.to_datetime
    end

    def notify_publisher
        if public?
            publisher = Rails.application.pastes_publisher
            publisher.send_json_msg(self.to_json) unless publisher.nil?
        end
    end

    def set_title
        self.title = 'Untitled' if self.title.blank?
    end

    def generate_token
        self.token = loop do
            random_token = SecureRandom.urlsafe_base64(10, false)
            break random_token unless Paste.exists?(token: random_token)
        end
    end
end
