class CollectPointsTour < ApplicationRecord
  self.table_name = "collect_points_tour"
  belongs_to :collectpoint, foreign_key: "collectpoint_id", class_name: "CollectPoint"
  belongs_to :tour
end
