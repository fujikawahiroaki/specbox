class CustomTaxon < ApplicationRecord
  self.table_name = "custom_taxa"
  self.primary_key = "taxon_ptr_id"
  belongs_to :auth_user
end
