require 'rails_helper'

RSpec.describe "post_categories/index", type: :view do
  before(:each) do
    assign(:post_categories, [
             PostCategory.create!(
               title: "Title",
               description: "MyText"
             ),
             PostCategory.create!(
               title: "Title",
               description: "MyText"
             )
           ])
  end

  it "renders a list of post_categories" do
    render
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
