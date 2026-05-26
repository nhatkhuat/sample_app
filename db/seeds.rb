# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Create a main sample user.
# 
User.find_or_create_by!(email: "example@railstutorial.org") do |user|
  user.name = "Example User"
  user.password = "foobar"
  user.password_confirmation = "foobar"
  user.admin = true
  user.activated = true
  user.activated_at = Time.zone.now
end

# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
    User.find_or_create_by!(email: email) do |user|
    user.name = name
    user.password = password
    user.password_confirmation = password
    user.activated = true
    user.activated_at = Time.zone.now
  end
end

# Generate microposts for a subset of users.
users = User.order(:created_at).take(6)

50.times do
content = Faker::Lorem.sentence(word_count: 5)
users.each { |user| user.microposts.find_or_create_by!(content: content) }
end

# Create following relationships.
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each do |followed|
  user.following << followed unless user.following.include?(followed)
end

followers.each do |follower|
  follower.following << user unless follower.following.include?(user)
end
