require 'rails_helper'

RSpec.describe "post_categories/index", type: :view do
  before do
    login_user
    FactoryBot.create_list(:post_category, 2)
    @post_categories = PostCategory.order(:id).page(1)
  end

  it "renders a list of post_categories" do
    render
    # assert_select "tr>td", text: "#{'a' * 50}2", count: 1
    # assert_select "tr>td", text: "#{'a' * 50}3", count: 1
    assert_select "tr>td", text: "a" * 100, count: 2
  end
end
