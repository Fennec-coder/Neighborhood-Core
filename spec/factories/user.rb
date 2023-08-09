require 'faker'

FactoryBot.define do
  factory :user do
    nickname { Faker::Internet.username }
    name     { Faker::Name.first_name }
    surname  { Faker::Name.last_name }
    email    { Faker::Internet.email }
    password { 'password' }

    confirmed_at { Time.now }
  end
end
