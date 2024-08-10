class SpecimenLabelsLabelSpecimen < ApplicationRecord
  self.table_name = "specimen_labels_label_specimens"
  belongs_to :specimenlabel
  belongs_to :specimen
end
