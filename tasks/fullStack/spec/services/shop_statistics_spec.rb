require 'rails_helper'

RSpec.describe ShopStatisticsService do
  describe ".calculate_average_ratings_change" do
    let(:product) { create(:product) }

    before do
      create(:review, product: product, rating: 4.1, created_at: 1.month.ago)
      create(:review, product: product, rating: 4.3, created_at: 1.month.ago)

      create(:review, product: product, rating: 3.4, created_at: 2.months.ago)
      create(:review, product: product, rating: 3.6, created_at: 2.months.ago)

      create(:review, product: product, rating: 4.7, created_at: 3.months.ago)
      create(:review, product: product, rating: 4.9, created_at: 3.months.ago)
    end

    it "returns the correct average ratings change" do
      result = ShopStatisticsService.calculate_average_ratings_change(product.shop)
      expect(result).to eq([-1.3, 0.7])
    end
  end
end
