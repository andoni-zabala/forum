# typed: false
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "CommunitiesController", type: :request do
  describe "GET /api/communities" do
    it "lists all communities" do
      create_list(:community, 3)
      get "/api/communities", as: :json

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
    end

    it "filters by titles when titles[] is provided" do
      create(:community, title: "Ruby Fans")
      create(:community, title: "Rails Lovers")
      create(:community, title: "Elixir Wizards")

      get "/api/communities", params: { titles: [ "Ruby", "Rails" ] }

      expect(response).to have_http_status(:ok)

      titles = JSON.parse(response.body).map { |c| c["title"] }
      expect(titles).to match_array([ "Ruby Fans", "Rails Lovers" ])
    end
  end

  describe "GET /api/communities/:id" do
    it "returns the community" do
      community = create(:community)
      get "/api/communities/#{community.id}", as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json["id"]).to eq(community.id)
      expect(json["title"]).to eq(community.title)
    end

    it "returns null body when not found" do
      get "/api/communities/0", as: :json

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq("null")
    end
  end

  describe "POST /api/communities" do
    it "creates a community and returns 201" do
      expect {
        post "/api/communities",
             params: { title: "New One", description: "Great" },
             as: :json
      }.to change(Community, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)

      expect(json["title"]).to eq("New One")
      expect(json["description"]).to eq("Great")
    end
  end

  describe "PATCH /api/communities/:id" do
    it "updates a community and returns 200" do
      community = create(:community, title: "Old", description: "Desc")
      patch "/api/communities/#{community.id}",
            params: { title: "Updated", description: "Updated desc" },
            as: :json

      expect(response).to have_http_status(:ok)
      community.reload

      expect(community.title).to eq("Updated")
      expect(community.description).to eq("Updated desc")

      json = JSON.parse(response.body)
      expect(json["title"]).to eq("Updated")
    end
  end

  describe "DELETE /api/communities/:id" do
    it "deletes a community and returns the deleted entity" do
      community = create(:community)
      expect {
        delete "/api/communities/#{community.id}", as: :json
      }.to change(Community, :count).by(-1)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["id"]).to eq(community.id)
    end
  end
end
