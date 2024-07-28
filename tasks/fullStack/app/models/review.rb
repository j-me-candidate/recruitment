class Review < ApplicationRecord
  belongs_to :product

  scope :months_ago, ->(n) { where(created_at: n.months.ago.beginning_of_month..n.months.ago.end_of_month) }
end
