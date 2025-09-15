# typed: strict

module Communities
  class ReadDto < T::Struct
    extend T::Sig

    const :title, String
  end
end
