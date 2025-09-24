# typed: true

class Community < ApplicationRecord
  sig { returns(Integer) }
  def id; end

  sig { returns(String) }
  def title; end

  sig { returns(T.nilable(String)) }
  def description; end

  sig { params(titles: T.nilable(T::Array[String])).returns(T.untyped) }
  def self.with_titles_like(titles); end
end
