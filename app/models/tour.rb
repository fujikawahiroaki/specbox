class Tour < ApplicationRecord
  self.table_name = "tours"
  self.primary_key = "id"
  belongs_to :auth_user, foreign_key: :user_id
  has_many :collect_points, through: :collect_points_tour

  attribute :id, :uuid, default: -> { SecureRandom.uuid }
  attribute :title, :string, default: ""
  attribute :track, :geography, default: nil
  attribute :note, :string, default: ""
  attribute :image1, :string, default: ""
  attribute :image2, :string, default: ""
  attribute :image3, :string, default: ""
  attribute :image4, :string, default: ""
  attribute :image5, :string, default: ""
end
