# typed: strict

# Skip seeding in test environment
return if defined?(Rails) && Rails.env.test?

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed data for Community model
[ {
  title: "Tech Enthusiasts",
  description: "A community for tech lovers to share and discuss the latest in technology."
}, {
  title: "Book Club",
  description: "A place for bookworms to discuss their favorite reads."
}, {
  title: "Fitness Freaks",
  description: "A community for fitness enthusiasts to share tips and motivate each other."
} ].each do |community_data|
  Community.find_or_create_by!(title: community_data[:title]) do |community|
    community.description = community_data[:description]
  end
end
