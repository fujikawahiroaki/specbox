class Tour < ApplicationRecord
  include ImagePath

  self.table_name = "tours"
  self.primary_key = "id"
  belongs_to :auth_user, foreign_key: :user_id
  has_many :collect_points, through: :collect_points_tour

  mount_uploader :image1, DjangoPictureUploader
  mount_uploader :image2, DjangoPictureUploader
  mount_uploader :image3, DjangoPictureUploader
  mount_uploader :image4, DjangoPictureUploader
  mount_uploader :image5, DjangoPictureUploader

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
