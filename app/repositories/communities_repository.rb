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
      to_entity(community)
    end
  end

  sig { params(dto: ShowDto).returns(T.nilable(Entity)) }
  def find(dto:)
    community = Community.find_by(dto.id)
    to_entity(community)
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

  sig { params(id: Integer).returns(T::Boolean) }
  def destroy(id)
    community = find(id)
    return false unless community

    community.destroy
    true
  end

  private

  sig { params(community: Community).returns(Entity) }
  def to_entity(community)
    ::Entities::CommunityEntity.new(
      id: community.id,
      title: community.title,
      description: community.description
    )
  end
end
