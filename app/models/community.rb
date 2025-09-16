# typed: strict

class Community < ApplicationRecord
    scope :with_titles_like, ->(titles) do
      return all if titles.blank?

      patterns = titles.map { |t| "%#{t}%" }
      where("title LIKE ANY (array[?])", patterns)
  end
end
