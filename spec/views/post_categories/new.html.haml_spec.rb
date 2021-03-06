require 'rails_helper'

RSpec.describe "post_categories/new", type: :view do
  before do
    login_user
    @post_category = FactoryBot.create(:post_category)
  end

  it "renders new post_category form" do
    render
    assert_select "form[action=?][method=?]", post_categories_path, "post" do
      assert_select "input[name=?]", "post_category[title]"
      assert_select "textarea[name=?]", "post_category[description]"
    end
  end
end
