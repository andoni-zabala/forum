# typed: strict

module Communities
  class UpdateDto < T::Struct
    extend T::Sig

    const :id, T.nilable(Integer)
    const :title, T.nilable(String)
    const :description, T.nilable(String)
  end
end
