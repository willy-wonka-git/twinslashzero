require 'pry'
require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    login_user
  end

  # subject {
  #   FactoryBot.create(:post)
  # }
  #
  # context "with 2 or more comments" do
  #   it "orders them in reverse chronologically" do
  #     post = FactoryBot.create(:post)
  #     tag1 = post.tags.find_first_or_create!(:name => "first tag")
  #     tag2 = post.tags.find_first_or_create!(:body => "second tag")
  #     expect(post.reload.tags).to eq([tag2, tag1])
  #   end
  # end

  # describe 'Validations' do
  #   binding.pry
  #   it { should validate_presence_of(:title) }
  #   it { should validate_presence_of(:content) }
  #   it { should validate_presence_of(:author) }
  #   it { should validate_presence_of(:category) }
  # end
  #
  # describe "Associations" do
  #   it { should belong_to(:author) }
  # end

  # it "is valid with valid attributes" do
  #   expect(subject).to be_valid
  # end

  # it "is not valid without a title" do
  #   subject.title = nil
  #   expect(subject).to_not be_valid
  # end  

  # it "is not valid without a content" do
  #   subject.content = nil
  #   expect(subject).to_not be_valid
  # end  
end
