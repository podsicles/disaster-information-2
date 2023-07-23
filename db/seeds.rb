# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
10.times do
  user = User.create!(email: Faker::Internet.email, password: 'qwer4321', password_confirmation: "qwer4321")
  puts "create user id: #{user.id}, email: #{user.email}"
end

categories = ['COVID', 'Earthquake', 'Requirements']

categories.each do |category|
  category = Category.find_or_create_by(name: category) 
end

30.times do |i|
  puts "start create #{i} post"
  region = Address::Region.find_by_name("National Capital Region")
  province = region.provinces.find_by_name("Fourth District")
  city = province.cities.find_by_name("City of Makati")
  barangay = city.barangays.sample

  post = Post.create(
    title: Faker::Lorem.sentence, 
    content: Faker::Lorem.paragraph, 
    user: User.all.sample, 
    categories: Category.all.sample((1..3).to_a.sample), 
    address: Faker::Address.street_address, 
    region: region,
    province: province,
    city: city,
    barangay: barangay,
    ip_address: Faker::Internet.public_ip_v4_address
  )
  (1..100).to_a.sample.times do
    Comment.create(content: Faker::Lorem.sentence, user: User.all.sample, post: post)
  end
  puts "finish #{i} post"
end