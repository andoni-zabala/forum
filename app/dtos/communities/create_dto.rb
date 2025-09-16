# typed: strict

module Communities
  class CreateDto < T::Struct
    extend T::Sig

    const :title, String
    const :description, String
  end
end
