require 'rails_helper'

RSpec.describe "/posts", type: :request do
  subject(:post_) { FactoryBot.create(:post, author: user, category: category) }

  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) do
    {
      author: user,
      category: category,
      category_id: category.id,
      title: 'a' * 50,
      content: 'a' * 200,
      tag_ids: []
    }
  end

  let(:category) { FactoryBot.create(:post_category) }

  before do
    login_user(:user, user)
  end

  describe "GET /index" do
    it "renders a successful response" do
      get posts_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get post_url(id: post_.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_post_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      get edit_post_url(id: post_.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Post" do
        expect do
          post posts_url, params: { post: valid_attributes }
        end.to change(Post, :count).by(1)
      end

      it "redirects to the created post" do
        post posts_url, params: { post: valid_attributes }
        expect(response).to redirect_to(post_url(Post.last))
      end
    end

    # context "with invalid parameters" do
    #   it "does not create a new Post" do
    #     expect do
    #       sign_in user
    #       post posts_url, params: { post: invalid_attributes }
    #     end.to change(Post, :count).by(0)
    #   end

    #   it "renders a successful response (i.e. to display the 'new' template)" do
    #     sign_in user
    #     post posts_url, params: { post: invalid_attributes }
    #     expect(response).to be_successful
    #   end
    # end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { title: 'b' * 50 }
      end

      it "updates the requested post" do
        post_ = FactoryBot.create(:post, author: user)
        patch post_url(id: post_.id), params: { post: new_attributes }
        post_.reload
        expect(post_.title).to eq('b' * 50)
      end

      it "redirects to the post" do
        post_ = FactoryBot.create(:post, author: user)
        patch post_url(id: post_.id), params: { post: new_attributes }
        post_.reload
        expect(response).to redirect_to(post_url(id: post_.id))
      end
    end

    # context "with invalid parameters" do
    #   it "renders a successful response (i.e. to display the 'edit' template)" do
    #     sign_in user
    #     post = Post.create! valid_attributes
    #     patch post_url(post), params: { post: invalid_attributes }
    #     expect(response).to be_successful
    #   end
    # end
  end

  describe "DELETE /destroy" do
    it "destroys the requested post" do
      post_ = FactoryBot.create(:post, author: user)
      expect do
        delete post_url(id: post_.id)
      end.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      post_ = FactoryBot.create(:post, author: user)
      delete post_url(id: post_.id)
      expect(response).to redirect_to(posts_url)
    end
  end
end
