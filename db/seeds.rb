# # Create user admin
# admin = User.create(
#   nickname: "admin",
#   role: "admin",
#   email: "admin@gmail.com",
#   password: "111111"
# )

# # Create users
# 80.times do
#   user = User.create(
#     nickname: Faker::Internet.user_name,
#     fullname: Faker::Name.name,
#     role: "user",
#     email: Faker::Internet.email,
#     password: Faker::Internet.password,
#     description: Faker::Lorem.paragraph
#   )

#   # users = User.order(:created_at).take(6)
#   # rand(1...15).times do
#   #   content = Faker::Lorem.sentence(word_count:15)
#   #   users.each { |user| user.diaries.create!(content: body) }
#   # end
# end

# Create categories
80.times do
  post_category = PostCategory.create(
    title: Faker::Hobby.activity,
    description: Faker::Lorem.paragraph
  )
end  
