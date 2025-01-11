# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

tours = []
1.upto(100) do |i|
  tours << { id: SecureRandom.uuid, user_id: 1, title: "テスト#{i}", start_date: Date.new(2024, 12, 1), end_date: Date.new(2025, 1, 3), note: "てすと\nいぇええい" }
end

Tour.create(tours)
