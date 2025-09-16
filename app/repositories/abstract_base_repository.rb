# typed: strict

require_relative "../entities/community_entity"
require_relative "../models/community"

class AbstractBaseRepository
  extend T::Sig
  extend T::Helpers
  abstract!

  Entity = T.type_alias { T::Struct }

  sig { abstract.paramaters(dto: T::Struct).returns(Entity) }
  def index(dto:); end
end
