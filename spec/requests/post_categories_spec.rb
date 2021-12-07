require 'rails_helper'

RSpec.describe "/post_categories", type: :request do
  subject(:post_category) { FactoryBot.create(:post_category) }

  before do
    login_user(:admin)
  end

  let(:valid_attributes) do
    { title: 'a' * 5, description: 'a' * 500 }
  end

  let(:invalid_attributes) do
    { title: 'a' * 2 }
  end

  describe "GET /index" do
    it "renders a successful response" do
      get post_categories_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get post_categories_url(id: post_category.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_post_category_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      get edit_post_category_url(id: post_category.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new PostCategory" do
        expect do
          post post_categories_url, params: { post_category: valid_attributes }
        end.to change(PostCategory, :count).by(1)
      end

      it "redirects to the created post_category" do
        post post_categories_url, params: { post_category: valid_attributes }
        expect(response).to redirect_to(post_category_url(PostCategory.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new PostCategory" do
        expect do
          post post_categories_url, params: { post_category: invalid_attributes }
        end.to change(PostCategory, :count).by(0)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        { title: 'b' * 50 }
      end

      it "updates the requested post_category" do
        patch post_category_url(id: post_category.id), params: { post_category: new_attributes }
        post_category.reload
        expect(post_category.title).to eq('b' * 50)
      end

      it "redirects to the post_category" do
        patch post_category_url(id: post_category.id), params: { post_category: new_attributes }
        post_category.reload
        expect(response).to redirect_to(post_category_url(post_category))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested post_category" do
      post_category = FactoryBot.create(:post_category)
      expect do
        delete post_category_url(id: post_category.id)
      end.to change(PostCategory, :count).by(-1)
    end

    it "redirects to the post_categories list" do
      post_category = FactoryBot.create(:post_category)
      delete post_category_url(id: post_category.id)
      expect(response).to redirect_to(post_categories_url)
    end
  end
end
