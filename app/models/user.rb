class User < ActiveRecord::Base
    has_many :pastes, dependent: :destroy
    before_save { email.downcase! }
    before_create :create_token
    
    VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, uniqueness: { case_sensitive: false }, presence: true, 
                      format: { with: VALID_EMAIL }
    has_secure_password
    validates :password, length: { minimum: 6 }
    validates :name, presence: true, length: { minimum: 3, maximum: 20 }

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def User.hash(token)
        Digest::SHA1.hexdigest(token.to_s)
    end

    private

    def create_token
        self.token = User.hash(User.new_token)
    end
end
