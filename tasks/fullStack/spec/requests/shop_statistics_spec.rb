require 'rails_helper'

RSpec.describe "Shop statistics" do
  describe "GET /shop_statistics/:id", type: :request do
    let(:product) { create(:product) }

    context "when the shop has reviews for the last three months" do
      before do
        create(:review, product: product, rating: 4.1, created_at: 1.month.ago)
        create(:review, product: product, rating: 4.3, created_at: 1.month.ago)

        create(:review, product: product, rating: 3.4, created_at: 2.months.ago)
        create(:review, product: product, rating: 3.6, created_at: 2.months.ago)

        create(:review, product: product, rating: 4.7, created_at: 3.months.ago)
        create(:review, product: product, rating: 4.9, created_at: 3.months.ago)
      end

      it "displays the average ratings change" do
        get "/shop_statistics/#{product.shop.id}"

        expect(response.body).to include("[-1.3, 0.7]")
      end
    end

    context "when the shop does not have reviews for the last three months" do
      it "displays a warning message" do
        get "/shop_statistics/#{product.shop.id}"

        expect(response.body).to include("Not enough data to calculate average ratings change for the last three months.")
      end
    end
  end
end
