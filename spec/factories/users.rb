# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'a@a.com'
    password 'aaaaaaaa'
    password_confirmation 'aaaaaaaa'

    factory :invalid_user do
      password_confirmation 'aaaaaaaA'
    end
  end
end
