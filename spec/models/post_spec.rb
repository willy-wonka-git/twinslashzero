require 'rails_helper'

RSpec.describe Post, type: :model do
  subject {
    FactoryBot.create(:post)
  } 

  describe 'Validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:category) }
    # it { should validate_uniqueness_of(:name).scoped_to(:category_id) }
  end

  describe "Associations" do
    it { should belong_to(:author) }
  end

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
