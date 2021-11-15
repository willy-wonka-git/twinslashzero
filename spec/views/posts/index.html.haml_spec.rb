require 'rails_helper'

RSpec.describe "posts/index", type: :view do
  before do
    login_user
    FactoryBot.create_list(:post, 2, aasm_state: "published", published_at: Time.zone.now)
    @posts = Post.published.order(:published_at).page(1)
  end

  it "renders a list of posts" do
    render
    assert_select "tr>td", text: "a" * 50, count: 2
  end
end
