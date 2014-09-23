namespace :db do
  desc 'データベースにサンプルデータを流し込む'
  task populate: :environment do
    user_count = 10
    user_count.times do
      password = Faker::Internet.password
      User.create(
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password)
    end
    100.times do
      user = User.offset(Random.rand(user_count)).first
      q = user.questions.create(
        title: Faker::Lorem.sentence,
        body: Faker::Lorem.paragraph(3))
      Random.rand(10).times do
          answer_user = User.offset(Random.rand(user_count)).first
          q.answers.create(
            user_id: answer_user.id,
            body: Faker::Lorem.paragraph(2))
      end
    end
  end
end
