require 'rails_helper'

RSpec.describe "post_categories/edit", type: :view do
  before(:each) do
    @post_category = assign(:post_category, PostCategory.create!(
                                              title: "MyString",
                                              description: "MyText"
                                            ))
  end

  it "renders the edit post_category form" do
    render

    assert_select "form[action=?][method=?]", post_category_path(@post_category), "post" do

      assert_select "input[name=?]", "post_category[title]"

      assert_select "textarea[name=?]", "post_category[description]"
    end
  end
end
