class ReviewsController < ApplicationController

  DEFAULT_TAGS = ['default']

  def index
    if params[:shop_id].present? && Shop.where("id = #{params[:shop_id]}").present?
      params[:per_page] ||= 10
      offset = params[:page].to_i * params[:per_page]

      @data = []
      products = Product.where("shop_id = #{params[:shop_id]}").sort_by(&:created_at)[offset..(offset + params[:per_page])]
      products.each do |product|
        reviews = product.reviews.sort_by(&:created_at)[offset..(offset + params[:per_page])]
        @data << { product: product, reviews: reviews }
      end
    end
  end

  def create
    # TODO: Create reviews in background

    tags = tags_with_default(params)
    Review.create(product_id: params[:product_id], body: params[:body], rating: params[:rating], tags: tags)

    flash[:notice] = 'Review is being created in background. It might take a moment to show up'
    redirect_to :index
  end

  private

  # Prepend params[:tags] with tags of the shop if present or DEFAULT_TAGS
  def tags_with_default(params)
    product = Product.find_by(id: params[:product_id])
    default_tags = product.shop.tags || DEFAULT_TAGS
    default_tags.concat(params[:tags].split(',')).uniq
  end

end
