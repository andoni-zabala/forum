require "rails_helper"

RSpec.describe CommunitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/communities").to route_to("communities#index")
    end

    it "routes to #show" do
      expect(get: "/api/communities/1").to route_to("communities#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/api/communities").to route_to("communities#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/communities/1").to route_to("communities#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/communities/1").to route_to("communities#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api/communities/1").to route_to("communities#destroy", id: "1")
    end
  end
end
