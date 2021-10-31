require 'rails_helper'

$count = 0
RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let(:count) { $count += 1 }

  it "memoizes the value" do
    p '>>>>' + count.to_s
    expect(count).to eq(1)
    p '>>>>' + count.to_s
    expect(count).to eq(1)
    p '>>>>' + count.to_s
  end

  it "is not cached across examples" do
    p '>>>>' + count.to_s
    expect(count).to eq(2)
    p '>>>>' + count.to_s
    expect(count).to eq(2)
    p '>>>>' + count.to_s
    p '>>>>' + count.to_s
  end 
  it "is not cached across examples" do
    p '>>>>' + count.to_s
    expect(count).to eq(3)
    p '>>>>' + count.to_s
    expect(count).to eq(3)
    p '>>>>' + count.to_s
    p '>>>>' + count.to_s
  end 
end
