require "rails_helper"

RSpec.describe PostCategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/categories").to route_to("post_categories#index")
    end

    it "routes to #new" do
      expect(get: "/categories/new").to route_to("post_categories#new")
    end

    it "routes to #show" do
      expect(get: "/categories/1").to route_to("post_categories#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/categories/1/edit").to route_to("post_categories#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/categories").to route_to("post_categories#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/categories/1").to route_to("post_categories#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/categories/1").to route_to("post_categories#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/categories/1").to route_to("post_categories#destroy", id: "1")
    end
  end
end
