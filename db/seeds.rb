# Create user admin
admin = User.new(
  email: "admin@gmail.com",
  password: "111111"
)
admin.save!

# Create users
80.times do
  user = User.new(
    # name: Faker::Internet.user_name,
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
  user.save!

	# users = User.order(:created_at).take(6)
	# rand(1...15).times do
	#   content = Faker::Lorem.sentence(word_count:15)
	#   users.each { |user| user.diaries.create!(content: body) }
	# end
end

