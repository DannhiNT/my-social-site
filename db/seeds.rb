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


5.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "123456",
    password_confirmation: "123456",
    username: Faker::Internet.unique.username
  )
  3.times do
    Post.create!(
      title: Faker::Book.title,
      body: Faker::Lorem.paragraph(sentence_count: 5),
      user: user
    )
  end
end

puts "Seeded 5 users with 3 posts each!"
