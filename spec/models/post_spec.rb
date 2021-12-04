require 'pry'
require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    login_user
  end

  subject(:post) { FactoryBot.create(:post) }

  # context "with 2 or more comments" do
  #   it "orders them in reverse chronologically" do
  #     tag1 = post.tags.find_first_or_create!(name: "first tag")
  #     tag2 = post.tags.find_first_or_create!(body: "second tag")
  #     expect(post.reload.tags).to eq([tag2, tag1])
  #   end
  # end

  describe "Associations" do
    it { should belong_to(:category).class_name('PostCategory') }
    it { should belong_to(:author).class_name('User') }
    it { should have_many(:tags) }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:category) }

    it "is valid with valid attributes" do
      expect(post).to be_valid
    end

    it "is valid title" do
      should validate_length_of(:title).is_at_least(5)
      should validate_length_of(:title).is_at_most(200)
    end

    it "is valid content" do
      should validate_length_of(:content).is_at_least(50)
      should validate_length_of(:content).is_at_most(2000)
    end
  end
end
