# Clear database
Tagging.all.delete_all
Tag.all.delete_all
PostHistory.all.delete_all
Post.all.delete_all
PostCategory.all.delete_all
User.all.delete_all
AdminUser.all.delete_all

AdminUser.create!(email: 'admin@gmail.com', password: '111111', password_confirmation: '111111')
User.create(
    nickname: "admin",
    role: "admin",
    email: "admin@gmail.com",
    password: "111111"
)
puts 'Created "admin" (email: admin@gmail.com, password: 111111)'

# Login
Current.user = User.find_by(nickname: :admin)

puts "Create categories..."
12.times do
  PostCategory.create(
    title: Faker::Hobby.activity,
    description: Faker::Lorem.paragraph
  )
end
puts "Done."

puts "Create tags..."
20.times do
  Tag.create(name: Faker::Superhero.power)
  Tag.create(name: Faker::Food.fruits)
end
puts "Done."

puts "Create users..."
80.times do
  User.create(
    nickname: Faker::Internet.user_name,
    fullname: Faker::Name.name,
    role: "user",
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    description: Faker::Lorem.paragraph
  )
end
puts "Done."

puts "Create posts"
users = User.order('RANDOM()').where(role: :user).take(50)
rand(1...10).times do
  users.each do |user|
    Current.user = user
    state = %w[draft new approved banned published archived].sample
    post = Post.create!(
      author: user,
      category: PostCategory.order('RANDOM()').first,
      title: Faker::Lorem.sentence(word_count: 12),
      content: Faker::Lorem.sentence(word_count: 30),
      aasm_state: state,
      published_at: state == "published" ? rand(1...90).hours.ago : nil
    )

    # Add tags
    rand(1..5).times do
      Tagging.create!(
        tag: Tag.order('RANDOM()').first,
        post: post
      )
    end

    # TODO Add images

    # TODO Add post history

    # post_history = PostHistory.create({ post: post, user: user, state: post.aasm.current_state })
    # post_history.reason = @state_reason if defined? @state_reason
    # post_history.save
  end
end
puts "Done."
