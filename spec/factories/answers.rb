# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    association :user
    association :question
    body { Faker::Lorem.paragraph }
  end
end
