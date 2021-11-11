require 'pry'
require 'rails_helper'

RSpec.describe "post_categories/edit", type: :view do
  before do
    @post_category = assign(:post_category, PostCategory.create!(
                                              title: "MyString",
                                              description: "MyText"
                                            ))
  end

  it "renders the edit post_category form" do
    # controller.extra_params = { @post_category => @post_category, :id => @post_category.id }
    render # template: 'post_categories/edit', :locals => { locale: :en, @post_category => @post_category }
    # assert_select "form[action=?][method=?]", post_categories_url(@post_category), "post" do
    binding.pry
    assert_select "form[method=?]", "post" do
      assert_select "input[name=?]", "post_category[title]"
      assert_select "textarea[name=?]", "post_category[description]"
    end
  end
end
