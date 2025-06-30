# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

User.destroy_all
Post.destroy_all
Follow.destroy_all
Comment.destroy_all

puts "Seeded 5 users with 3 posts each. Each post has 2 comments!"
5.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "123456",
    password_confirmation: "123456",
    username: Faker::Internet.unique.username
  )
  3.times do
    post = Post.create!(
      title: Faker::Book.title,
      body: Faker::Lorem.paragraph(sentence_count: 5),
      user: user
    )

    2.times do
      Comment.create!(
        body: Faker::Lorem.sentence,
        user: User.all.sample,
        post: post
      )
    end
  end
end

puts "Creating follow requests & accepted follows..."

User.all.each do |user|
  others = User.all - [ user ]
  others.sample(2).each do |other|
    Follow.create!(
    follower: user,
    followed: other,
    status: "pending"
  )
  end
  follower = others.sample
  Follow.create!(
    follower: follower,
    followed: user,
    status: "accepted"
  )
end
