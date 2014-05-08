require 'date'

FactoryGirl.define do
    factory :user do
        name "testuser"
        email "valid@email.com"
        password "heythere22"
        password_confirmation "heythere22"
    end

    factory :paste do
        title "sillytitle"
        content "SILLYCONTENT"
        expiration Time.now.utc
        exposure 1
    end
end
