# typed: strict

class CommunityEntity < T::Struct
  extend T::Sig

  const :id, Integer
  const :title, String
  const :description, String
end
