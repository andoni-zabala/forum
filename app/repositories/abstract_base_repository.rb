# typed: strict

require_relative "../entities/community_entity"
require_relative "../models/community"

class AbstractBaseRepository
  extend T::Sig
  extend T::Helpers
  extend T::Generic

  abstract!

  Entity = type_member { { upper: T::Struct } }

  sig { returns(T.untyped) }
  def self.entity
    T.unsafe(const_get(:Entity)).inner_type[:fixed]
  end

  sig { overridable.params(dto: T.untyped).returns(T::Array[Entity]) }
  def read(dto:)
    raise_error(__method__)
  end

  sig { overridable.params(dto: IdDto).returns(T.nilable(Entity)) }
  def find(dto:)
    raise_error(__method__)
  end

  sig { overridable.params(dto: T.untyped).returns(Entity) }
  def create(dto:)
    raise_error(__method__)
  end

  sig { overridable.params(dto: T.untyped).returns(T.nilable(Entity)) }
  def update(dto:)
    raise_error(__method__)
  end

  sig { overridable.params(dto: IdDto).returns(T.nilable(Entity)) }
  def destroy(dto:)
    raise_error(__method__)
  end

  private

  sig { params(method: T.nilable(Symbol)).returns(T.noreturn) }
  def raise_error(method)
    raise NotImplementedError,
          "#{method} must be implemented in #{self.class} repository"
  end
end
