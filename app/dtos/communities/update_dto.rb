# typed: strict

module Communities
  class UpdateDto < T::Struct
    extend T::Sig

    const :id, Integer
    const :title, String
    const :description, String
  end
end
