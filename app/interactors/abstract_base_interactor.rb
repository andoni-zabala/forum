# typed: strict

class AbstractBaseInteractor
  extend T::Sig
  extend T::Helpers
  extend T::Generic

  abstract!

  Model = type_member { { upper: ApplicationRecord } }

  sig { params(dto: T::Struct) }
  def initialize(dto:)
    @dto = dto
  end

  sig { returns(Model) }
  def call
    ApplicationRecord.transaction do
      binding.pry
      execute
    end
  end

  private

  sig { abstract.returns(Model) }
  def execute; end
end
