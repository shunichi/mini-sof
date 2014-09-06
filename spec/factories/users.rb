FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { |u| u.password }

    factory :invalid_user do
      password_confirmation { |u| u.password + 'A' }
    end
  end
end
