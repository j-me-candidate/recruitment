# spec/system/reviews_index_spec.rb
require 'rails_helper'

RSpec.describe 'Reviews page', type: :system do
  let(:shop_1) { create(:shop) }
  let(:shop_2) { create(:shop) }

  let!(:shop_1_products) { create_list(:product, 2, :with_6_reviews, shop: shop_1) }
  let!(:shop_2_products) { create_list(:product, 2, :with_6_reviews, shop: shop_2) }

  before do
    driven_by(:rack_test)
  end

  context "when no shop is specified" do
    before { visit reviews_path }

    context "when on page 1" do
      it "displays the first two products" do
        shop_1_products.each do |product|
          expect(page).to have_content(product.title)
        end
      end

      it "does not display the remaining products" do
        shop_2_products.each do |product|
          expect(page).not_to have_content(product.title)
        end
      end

      it "displays the first three reviews for each visible product" do
        shop_1_products.each do |product|
          product.reviews.first(3).each do |review|
            expect(page).to have_content(review.body)
          end
        end
      end

      it "does not display the remaining reviews for each visible product" do
        shop_1_products.each do |product|
          product.reviews.last(3).each do |review|
            expect(page).not_to have_content(review.body)
          end
        end
      end
    end

    context "when on page 2" do
      before do
        within('div.product__pagination') do
          click_on "Next"
        end
      end

      it "displays the next set of products" do
        shop_2_products.each do |product|
          expect(page).to have_content(product.title)
        end
      end

      it "does not display the previous set of products" do
        shop_1_products.each do |product|
          expect(page).not_to have_content(product.title)
        end
      end
    end
  end

  context "when a shop is specified" do
    before { visit reviews_path(shop_id: shop_2.id) }

    it "displays the products of the specified shop" do
      shop_2_products.each do |product|
        expect(page).to have_content(product.title)
      end
    end

    it "does not display the products of other shops" do
      shop_1_products.each do |product|
        expect(page).not_to have_content(product.title)
      end
    end
  end
end
