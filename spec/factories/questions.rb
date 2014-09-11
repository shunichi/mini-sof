# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    association :user
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    accepted_answer nil
  end
end
