# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(fullname:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true
            )

5.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(fullname: name,
              email: email,
              password:              password,
              password_confirmation: password)
end

# # Microposts
# users = User.order(:created_at).take(6)
# 50.times do
#   content = Faker::Lorem.sentence(5)
#   users.each { |user| user.microposts.create!(content: content) }
# end

# Following relationships
users = User.all
user  = users.first
following = users[2..5]
followers = users[3..5]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# Insert Categories
5.times do |n|
  name = "Category-#{n}"
  Category.create!(name: name)
end

# Insert word
categories = Category.all
5.times do |n|
  categories.each do |category|
    body = Faker::Lorem.word
    Word.create!(body: body, category_id: category.id)
  end
end

# Insert Answer
words = Word.all
4.times do |n|
  status = false
  status = true if n == 3
  words.each do |word|
    body = Faker::Lorem.word
    Answer.create!(body: body, word_id: word.id, status: status)
  end
end 