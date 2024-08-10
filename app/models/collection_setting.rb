class CollectionSetting < ApplicationRecord
  self.table_name = "collection_settings"
  self.primary_key = "id"
  belongs_to :auth_user
end
