class ShopStatisticsController < ApplicationController

  def show
    @shop = Shop.find(params[:id])

    if @shop.has_last_three_months_of_reviews?
      @average_ratings_change = ShopStatisticsService.calculate_average_ratings_change(@shop)
    else
      @average_ratings_change = "Not enough data to calculate average ratings change for the last three months."
    end
  end
end

