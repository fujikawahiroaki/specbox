class DefaultTaxon < ApplicationRecord
  self.table_name = "default_taxa"
  self.primary_key = "taxon_ptr_id"
end
