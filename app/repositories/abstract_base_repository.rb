# typed: strict

require_relative "../entities/community_entity"
require_relative "../models/community"

class AbstractBaseRepository
  extend T::Sig
  extend T::Helpers
  extend T::Generic
  abstract!

  Entity = type_member(:out)

  sig { abstract.params(dto: T.untyped).returns(T::Array[Entity]) }
  def read(dto:); end

  sig { abstract.params(dto: IdDto).returns(T.nilable(Entity)) }
  def find(dto:); end

  sig { abstract.params(dto: T.untyped).returns(Entity) }
  def create(dto:); end

  sig { abstract.params(dto: T.untyped).returns(T.nilable(Entity)) }
  def update(dto:); end

  sig { abstract.params(dto: IdDto).returns(T.nilable(Entity)) }
  def destroy(dto:); end
end
