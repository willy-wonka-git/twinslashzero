FactoryBot.define do
  factory :admin, class: "User" do
    email { "admin@gmail.com" }
    nickname { "admin" }
    password { "1" * 6 }
    role { "admin" }
  end

  factory :user do
    sequence(:email) { |n| "user#{n}@gmail.com" }
    sequence(:nickname) { |n| "user#{n}" }
    sequence(:fullname) { |n| "user#{n}" }
    password { "1" * 6 }
    role { "user" }
  end

  factory :post_category do
    sequence(:title) { |n| ("a" * 50) + n.to_s }
    description { "a" * 100 }
  end

  factory :post do
    association :author, factory: :user
    association :category, factory: :post_category
    title { "a" * 50 }
    content { "a" * 200 }
    # image Rack::Test::UploadedFile.new(Rails.root + "spec/files/images/coffee.jpg", "image/jpg")
  end
end
