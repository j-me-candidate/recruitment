class ShopStatisticsService
  def self.calculate_average_ratings_change(shop)
    last_three_months = [
      3.months.ago.beginning_of_month,
      2.months.ago.beginning_of_month,
      1.month.ago.beginning_of_month
    ]

    average_ratings = last_three_months.map do |month|
      reviews = shop.reviews.where(created_at: month.beginning_of_month..month.end_of_month)
      reviews.average(:rating).to_f
    end

    average_ratings.each_cons(2).map { |a, b| (b - a).round(1) }
  end
end
