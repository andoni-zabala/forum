# frozen_string_literal: true

FactoryBot.define do
  factory :community do
    sequence(:title) { |n| "Community #{n}" }
    description { "A nice place to talk" }
  end
end
