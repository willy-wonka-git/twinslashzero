require 'rails_helper'

RSpec.describe "posts/new", type: :view do
  before do
    login_user
    @post = FactoryBot.create(:post)
  end

  it "renders new post form" do
    render
    assert_select "form[method=?]", "post" do
      assert_select "select[name=?]", "post[category_id]"
      assert_select "input[name=?]", "post[title]"
      assert_select "textarea[name=?]", "post[content]"
    end
  end
end
