class CollectPointsTour < ApplicationRecord
  self.table_name = "collect_points_tour"
  belongs_to :collectpoint
  belongs_to :tour
end
