class ReviewCreationWorker
  include Sidekiq::Worker

  def perform(product_id, body, rating, reviewer_name, tags)
    product = Product.find(product_id)
    product.reviews.create!(body: body, rating: rating, reviewer_name: reviewer_name, tags: tags)
  end
end
