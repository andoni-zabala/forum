# typed: false

class AbstractBaseInteractor
  extend T::Sig
  extend T::Helpers
  extend T::Generic

  abstract!

  Model = type_member { { upper: ApplicationRecord } }

  sig { params(dto: T::Struct).void }
  def initialize(dto:)
    @dto = dto
  end

  sig { returns(Model) }
  def call
    ApplicationRecord.transaction do
      execute
    end
  end

  private

  sig { abstract.returns(Model) }
  def execute; end
end
