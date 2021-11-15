require 'rails_helper'

RSpec.describe "posts/show", type: :view do
  before do
    login_user
    @post = FactoryBot.create(:post)
  end

  it "renders attributes" do
    render
    expect(rendered).to match(/a{50}/)
    expect(rendered).to match(/a{200}/)
  end
end
