class CollectionSetting < ApplicationRecord
  self.table_name = "collection_settings"
  self.primary_key = "id"
  belongs_to :auth_user, foreign_key: :user_id

  attribute :id, :uuid, default: -> { SecureRandom.uuid }
  attribute :collection_name, :string, default: ""
  attribute :institution_code, :string, default: ""
  attribute :latest_collection_code, :integer, default: 0
  attribute :note, :string, default: ""

  validates :collection_name, length: { minimum: 0, maximum: 174 }, exclusion: { in: [ nil ] }
  validates :institution_code, length: { minimum: 0, maximum: 10 }, exclusion: { in: [ nil ] }
  validates :latest_collection_code, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999999999999999999 }, exclusion: { in: [ nil ] }
  validates :note, length: { minimum: 0, maximum: 200 }, exclusion: { in: [ nil ] }

  ransacker :created_at_date do
    Arel.sql("DATE(created_at)")
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "collection_name", "institution_code", "latest_collection_code", "note", "created_at_date" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
