# typed: strict

require_relative "../entities/community_entity"
require_relative "../models/community"

class CommunitiesRepository < AbstractBaseRepository
  extend T::Sig

  Entity = T.type_alias { CommunityEntity }

  sig { override.params(dto: Communities::ReadDto).returns(T::Array[Entity]) }
  def read(dto:)
    communities = Community.with_titles_like(dto.titles)

    communities.map do |community|
      to_entity(community: community)
    end
  end

  sig { params(dto: IdDto).returns(T.nilable(Entity)) }
  def find(dto:)
    community = community_by_id(id: dto.id)
    to_entity(community: community) if community
  end

  sig { params(dto: Communities::CreateDto).returns(Entity) }
  def create(dto:)
    community = Community.new(title: dto.title, description: dto.description)
    community.save!

    to_entity(community: community)
  end

  sig { params(dto: Communities::UpdateDto).returns(T.nilable(Entity)) }
  def update(dto:)
    community = community_by_id(id: dto.id)

    if community
      community.update!(title: dto.title, description: dto.description)
      to_entity(community: community)
    end
  end

  sig { params(dto: IdDto).returns(T.nilable(Entity)) }
  def destroy(dto:)
    community = community_by_id(id: dto.id)

    if community
      community = community.destroy!
      to_entity(community: community)
    end
  end

  private

  sig { params(community: Community).returns(Entity) }
  def to_entity(community:)
    CommunityEntity.new(
      id: community.id,
      title: community.title,
      description: community.description
    )
  end

  sig { params(id: Integer).returns(T.nilable(Community)) }
  def community_by_id(id:)
    Community.find_by(id: id)
  end
end
