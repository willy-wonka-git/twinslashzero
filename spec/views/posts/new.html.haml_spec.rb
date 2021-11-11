require 'rails_helper'

RSpec.describe "posts/new", type: :view do

  # FactoryBot.define do
  #   factory :user, aliases: [:author] do
  #     nickname { "J" * 3 }
  #     email { "asfas@dsfdsf.com" }
  #     password { "fdfsdfsd" }
  #   end

  #   factory :post_category, aliases: [:category] do
  #     title { "J" * 5 }
  #   end

  #   factory :post do
  #     author
  #     category
  #     title { "MyString" }
  #     content { "MyText" }

  #   end
  # end

  before do
    assign(:post, Post.new(
                    author: "",
                    # category: "",
                    title: "MyString",
                    content: "MyText"
                  ))
  end

  it "renders new post form" do
    @post = build(:post)
    render

    assert_select "form[action=?][method=?]", posts_path, "post" do

      # assert_select "input[name=?]", "post[author]"

      assert_select "select[name=?]", "post[category_id]"

      assert_select "input[name=?]", "post[title]"

      assert_select "textarea[name=?]", "post[content]"
    end
  end
end
