# Clear database
Tagging.all.delete_all
Tag.all.delete_all
Post.all.delete_all
PostCategory.all.delete_all
User.all.delete_all

# Create user admin
User.create(
  nickname: "admin",
  role: "admin",
  email: "admin@gmail.com",
  password: "111111"
)

# Create categories
12.times do
  PostCategory.create(
    title: Faker::Hobby.activity,
    description: Faker::Lorem.paragraph
  )
end

# Create tags
20.times do
  Tag.create(name: Faker::Superhero.power)
  Tag.create(name: Faker::Food.fruits)
end

# Create users
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

# Create posts
users = User.order('RANDOM()').take(50)
rand(1...10).times do
  users.each do |user|
    post = Post.create!(
      author: user,
      category: PostCategory.order('RANDOM()').first,
      title: Faker::Lorem.sentence(word_count: 12),
      content: Faker::Lorem.sentence(word_count: 30),
      published_at: rand(1...90).hours.ago # for test an archiving
    )
    # Add tags
    rand(1..4).times do
      Tagging.create!(
        tag: Tag.order('RANDOM()').first,
        post: post
      )
    end
  end
end
