require 'rails_helper'

RSpec.describe PostCategory, type: :model do
  subject(:post_category) { FactoryBot.create(:post_category) }

  before do
    login_user(:admin)
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(post_category).to be_valid
    end

    it { expect(post_category).to validate_presence_of(:title) }

    it "is valid title" do
      expect(post_category).to validate_length_of(:title).is_at_least(3)
      expect(post_category).to validate_length_of(:title).is_at_most(200)
    end

    it "is valid description" do
      expect(post_category).to validate_length_of(:description).is_at_most(1000)
    end

    it { expect(post_category).to validate_uniqueness_of(:title).case_insensitive }
  end
end
