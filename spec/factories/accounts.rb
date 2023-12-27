FactoryBot.define do
  factory :account do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    sequence(:email) { |n| "person#{n}@example.com" }
    role { 'user' }
  end
end
