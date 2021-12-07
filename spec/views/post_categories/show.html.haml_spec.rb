require "pry"
require 'rails_helper'

RSpec.describe "post_categories/show", type: :view do
  let(:post_category) do
    login_user(:admin)
    FactoryBot.create(:post_category)
  end

  let(:posts) do
    login_user
    FactoryBot.create_list(:post, 2, category: post_category, published_at: Time.zone.now, aasm_state: "published")
    post_category.posts.page(1)
  end

  it "renders attributes" do
    @post_category = post_category
    @posts = posts
    render
    expect(rendered).to match(/a{50}/)
    expect(rendered).to match(/a{100}/)
    assert_select "tr>td", text: "a" * 50
  end
end
