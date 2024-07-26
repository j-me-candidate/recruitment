require 'rails_helper'

RSpec.describe "Reviews" do
  describe "POST /reviews", type: :request do
    let(:product) { create(:product) }
    let(:params) do
      {
        review: {
          product_id: product.id,
          body: "This is a review",
          rating: 5,
          reviewer_name: "John Doe",
          tags: "given_tag1,given_tag2"
        }
      }
    end

    it "creates an asynchronous job to create a review" do
      post "/reviews", params: params

      expected_tags = product.shop.tags.concat %w[given_tag1 given_tag2]
      expect(ReviewCreationWorker).to have_enqueued_sidekiq_job(product.id.to_s, "This is a review", "5", "John Doe", expected_tags)
    end

    it "redirects to the product's reviews page" do
      post "/reviews", params: params

      expect(response).to redirect_to reviews_path(shop_id: product.shop_id)
    end
  end
end
