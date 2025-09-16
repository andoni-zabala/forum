# typed: strict

class IdDto < T::Struct
  extend T::Sig

  const :id, Integer
end
