class SpecimenLabel < ApplicationRecord
  self.table_name = "specimen_labels"
  self.primary_key = "id"
  belongs_to :auth_user
  has_many :specimens
end
