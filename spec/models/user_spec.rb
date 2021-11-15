require 'rails_helper'

# $count = 0
RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  # it "memoizes the value" do
  #   # user = build(:user)
  #   # user.save!
  #   # p user.created_at
  #   # expect(user.nickname).to eq("John1")
  #   # Timecop.travel(2.days.from_now)
  #   user2 = build_stubbed(:user)
  #   p user2.email
  #   p user2.nickname
  #   p user2.fullname

  # end

  # let(:count) { $count += 1 }

  # it "memoizes the value" do
  #   p '>>>>' + count.to_s
  #   expect(count).to eq(1)
  #   p '>>>>' + count.to_s
  #   expect(count).to eq(1)
  #   p '>>>>' + count.to_s
  # end

  # it "is not cached across examples" do
  #   p '>>>>' + count.to_s
  #   expect(count).to eq(2)
  #   p '>>>>' + count.to_s
  #   expect(count).to eq(2)
  #   p '>>>>' + count.to_s
  #   p '>>>>' + count.to_s
  # end
  # it "is not cached across examples" do
  #   p '>>>>' + count.to_s
  #   expect(count).to eq(3)
  #   p '>>>>' + count.to_s
  #   expect(count).to eq(3)
  #   p '>>>>' + count.to_s
  #   p '>>>>' + count.to_s
  # end
end
