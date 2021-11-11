require 'rails_helper'

RSpec.describe "post_categories/show", type: :view do
  before do
    @post_category = assign(:post_category, PostCategory.create!(
                                              title: "Title",
                                              description: "MyText"
                                            ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
