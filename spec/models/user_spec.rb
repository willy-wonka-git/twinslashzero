require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.create(:user) }

  describe "Validations" do
    it { expect(user).to validate_presence_of(:nickname) }
    it { expect(user).to validate_presence_of(:email) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is valid nickname" do
      expect(user).to validate_length_of(:nickname).is_at_least(5)
      expect(user).to validate_length_of(:nickname).is_at_most(30)
    end

    it "is valid description" do
      expect(user).to validate_length_of(:description).is_at_most(200)
    end
  end

end
