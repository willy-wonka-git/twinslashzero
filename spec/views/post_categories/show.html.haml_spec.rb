require "pry"
require 'rails_helper'

RSpec.describe "post_categories/show", type: :view do
  before do
    login_user(:admin)
    @post_category = FactoryBot.create(:post_category)

    login_user
    FactoryBot.create_list(:post, 2, category: @post_category, published_at: Time.zone.now, aasm_state: "published")
    @posts = @post_category.posts.page(1)
  end

  it "renders attributes" do
    render
    expect(rendered).to match(/a{50}/)
    expect(rendered).to match(/a{100}/)
    assert_select "tr>td", text: "a" * 50
  end
end
