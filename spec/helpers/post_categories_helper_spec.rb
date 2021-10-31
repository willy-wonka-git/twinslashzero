require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PostCategoriesHelper. For example:
#
# describe PostCategoriesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PostCategoriesHelper, type: :helper do
  it "has a title" do
    item = PostCategory.create!(title: "My awesome title")
    expect(item.title).to eq("My awesome title")
  end
  pending "add some examples to (or delete) #{__FILE__}"
end
