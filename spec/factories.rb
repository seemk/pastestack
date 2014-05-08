require 'securerandom'

FactoryGirl.define do
    factory :user do
        name "testuser"
        email "valid@email.com"
        password "heythere22"
        password_confirmation "heythere22"
    end

    factory :paste do
        title SecureRandom.hex(10)
        content "SILLYCONTENT"
    end
end
