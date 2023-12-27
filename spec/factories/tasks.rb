FactoryBot.define do
  factory :task do
    mission
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { 'new' }
  end
end
