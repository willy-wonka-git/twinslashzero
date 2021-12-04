require 'rails_helper'

RSpec.describe PostCategory, type: :model do
  before do
    login_admin
  end

  subject(:post_category) { FactoryBot.create(:post_category) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(post_category).to be_valid
    end

    it { should validate_presence_of(:title) }

    it "is valid title" do
      should validate_length_of(:title).is_at_least(3)
      should validate_length_of(:title).is_at_most(200)
    end

    it "is valid description" do
      should validate_length_of(:description).is_at_most(1000)
    end

    it { should validate_uniqueness_of(:title).case_insensitive }
  end
end
