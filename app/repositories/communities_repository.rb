# typed: strict

require_relative "../entities/community_entity"
require_relative "../models/community"

class CommunitiesRepository
  extend T::Sig

  Entity = T.type_alias { ::Entities::CommunityEntity }

  sig { params(dto: Communities::ReadDto).returns(T::Array[Entity]) }
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

  sig { params(attributes: T::Hash[Symbol, T.untyped]).returns(Community) }
  def create(attributes)
    Community.create!(attributes)
  end

  sig { params(id: Integer, attributes: T::Hash[Symbol, T.untyped]).returns(T.nilable(Community)) }
  def update(id, attributes)
    community = find(id)
    return nil unless community

    community.update!(attributes)
    community
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
    ::Entities::CommunityEntity.new(
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
