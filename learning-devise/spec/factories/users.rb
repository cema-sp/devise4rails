# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "user@example.com"
    username "username"
    address "address"
    confirmed_at Time.now # "2014-11-04 17:11:04"
    password "password"
    password_confirmation "password"
  end
end
