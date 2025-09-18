# typed: strict

module Communities
  class CreateInteractor < AbstractBaseInteractor
    extend T::Sig

    Model = type_member { { fixed: Community } }

    sig { params(dto: Communities::CreateDto).void }
    def initialize(dto:)
      @dto = dto
    end

    private

    sig { override.returns(Model) }
    def execute
      Community.new(title: dto.title, description: dto.description)
    end

    private
    attr_reader :dto
  end
end
