# ユーザー
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# マイクロポスト
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# db/seeds.rb
# users = [
#   { name: "Example User", email: "example@example.com", password: "password", password_confirmation: "password" },
#   { name: "John Doe", email: "john@example.com", password: "password", password_confirmation: "password" },
#   { name: "Jane Smith", email: "jane@example.com", password: "password", password_confirmation: "password" }
# ]

# users.each do |user_data|
#   User.find_or_create_by!(email: user_data[:email]) do |user|
#     user.name = user_data[:name]
#     user.password = user_data[:password]
#     user.password_confirmation = user_data[:password_confirmation]
#   end
# end

# puts "Seed data successfully created!"