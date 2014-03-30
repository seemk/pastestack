class User < ActiveRecord::Base
    before_save { email.downcase! }
    
    VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, uniqueness: { case_sensitive: false }, presence: true, 
                      format: { with: VALID_EMAIL }

    has_secure_password
    validates :password, length: { minimum: 6 }
end
