class Shop < ApplicationRecord
  has_many :products
  has_many :reviews, through: :products

  def has_last_three_months_of_reviews?
    reviews.months_ago(1).present? && reviews.months_ago(2).present? && reviews.months_ago(3).present?
  end
end
