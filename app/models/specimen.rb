class Specimen < ApplicationRecord
  self.table_name = "specimens"
  self.primary_key = "id"
  belongs_to :collect_point_info
  belongs_to :collection_settings_info
  belongs_to :custom_taxon_info
  belongs_to :default_taxon_info
  belongs_to :tour
  belongs_to :auth_user
  has_many :specimen_labels
end
