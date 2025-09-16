# typed: strict

module Communities
  class ReadDto < T::Struct
    extend T::Sig

    const :titles, T.nilable(T::Array[String])
  end
end
