require 'rails_helper'

RSpec.describe "post_categories/edit", type: :view do
  before do
    login_user
    @post_category = FactoryBot.create(:post_category)
  end

  it "renders the edit post_category form" do
    render
    assert_select "form[method=?]", "post" do
      assert_select "input[name=?]", "post_category[title]"
      assert_select "textarea[name=?]", "post_category[description]"
    end
  end
end
