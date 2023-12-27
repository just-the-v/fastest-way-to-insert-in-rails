FactoryBot.define do
  factory :mission do
    account
    name { Faker::Lorem.sentence }
    due_date { Faker::Date.in_date_period.to_time.to_i }
  end
end
