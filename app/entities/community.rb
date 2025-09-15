# typed: strict

module Entities
  class Community < T::Struct
    extend T::Sig

    const :id, Integer
    const :title, String
    const :description, String
  end
end
