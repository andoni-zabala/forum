# typed: strict

require_relative "../entities/community"

class CommunitiesRepository
  extend T::Sig

  sig { params(dto: Communities::ReadDto).returns(T::Array[::Entities::Community]) }
  def read(dto:)
    # Community.all.to_a
    [ ::Entities::Community.new(id: 1, title: "Example", description: "An example community") ]
  end

  sig { params(id: Integer).returns(T.nilable(Community)) }
  def find(id)
    Community.find_by(id: id)
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
end
