# typed: false
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommunitiesRepository, type: :model do
  subject(:repo) { described_class.new }

  describe "#read" do
    it "returns all entities when no titles provided" do
      community_one = create(:community, title: "Ruby")
      community_two = create(:community, title: "Rails")

      dto = Communities::ReadDto.new(titles: nil)
      entities = repo.read(dto: dto)

      expect(entities.map(&:id)).to match_array([ community_one.id, community_two.id ])
      expect(entities).to all(be_a(CommunityEntity))
    end

    it "filters by titles" do
      community_one = create(:community, title: "Ruby Fans")
      community_two = create(:community, title: "Rails Lovers")
      community_three = create(:community, title: "Elixir Wizards")

      dto = Communities::ReadDto.new(titles: [ "Ruby", "Rails" ])
      entities = repo.read(dto: dto)

      expect(entities.map(&:id)).to match_array([ community_one.id, community_two.id ])
    end
  end

  describe "#find" do
    it "returns entity when found" do
      community = create(:community)
      dto = IdDto.new(id: community.id)
      entity = repo.find(dto: dto)

      expect(entity&.id).to eq(community.id)
      expect(entity).to be_a(CommunityEntity)
    end

    it "returns nil when not found" do
      dto = IdDto.new(id: 0)
      expect(repo.find(dto: dto)).to be_nil
    end
  end

  describe "#create" do
    it "persists and returns entity" do
      dto = Communities::CreateDto.new(title: "New", description: "Desc")
      entity = repo.create(dto: dto)

      expect(entity).to be_a(CommunityEntity)
      expect(Community.exists?(entity.id)).to be true

      record = Community.find(entity.id)

      expect(record.title).to eq("New")
      expect(record.description).to eq("Desc")
    end
  end

  describe "#update" do
    it "updates and returns entity when found" do
      community = create(:community, title: "Old", description: "Old desc")
      dto = Communities::UpdateDto.new(id: community.id, title: "New", description: "New desc")

      entity = repo.update(dto: dto)

      expect(entity).to be_a(CommunityEntity)

      community.reload

      expect(community.title).to eq("New")
      expect(community.description).to eq("New desc")
    end

    it "returns nil when not found" do
      dto = Communities::UpdateDto.new(id: 0, title: "X", description: "Y")
      expect(repo.update(dto: dto)).to be_nil
    end
  end

  describe "#destroy" do
    it "destroys and returns entity when found" do
      community = create(:community)
      dto = IdDto.new(id: community.id)
      entity = repo.destroy(dto: dto)

      expect(entity).to be_a(CommunityEntity)
      expect(Community.exists?(community.id)).to be false
    end

    it "returns nil when not found" do
      dto = IdDto.new(id: 0)
      expect(repo.destroy(dto: dto)).to be_nil
    end
  end
end
