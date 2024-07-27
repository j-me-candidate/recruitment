class ReviewsController < ApplicationController
  before_action :set_shop, only: [:index]

  DEFAULT_TAGS = ['default']

  def new
    @review = Product.find(params[:product_id]).reviews.new
  end

  def index
    @shops = Shop.order(:name).pluck(:name, :id)

    respond_to do |format|
      format.html do
        @products = fetch_products
        @paginated_reviews = paginate_reviews_for_products(@products)
      end
      format.js do
        @product = Product.find(params[:product_id])
        @paginated_reviews = paginate_reviews_for_product(@product)
      end
    end
  end

  def create
    ReviewCreationWorker.perform_async(review_params[:product_id],
                                       review_params[:body],
                                       review_params[:rating],
                                       review_params[:reviewer_name],
                                       tags_with_default(review_params))
    flash[:notice] = 'Review is being created in background. It might take a moment to show up'
    redirect_to action: :index, shop_id: Product.find_by(id: review_params[:product_id]).shop_id
  end

  private

  def review_params
    params.require(:review).permit(:body, :rating, :reviewer_name, :tags, :product_id)
  end

  # Prepend `params[:tags]` with tags of the shop (if present) or DEFAULT_TAGS
  # For simplicity, let's skip the frontend for `tags`, and just assume frontend can somehow magically send to backend `params[:tags]` as a comma-separated string
  # The logic/requirement of tags is that:
  #  - A review can have `tags` (for simplicity, tags are just an array of strings)
  #  - If the shop has some `tags`, those tags of the shop should be part of the review's `tags`
  #  - Else (if the shop doesn't have any `tags`), the default tags (in constant `DEFAULT_TAGS`) should be part of the review's `tags`
  # One may wonder what an odd logic and lenthy comment, thus may suspect something hidden here, an easter egg perhaps.
  def tags_with_default(params)
    product = Product.find_by(id: params[:product_id])
    default_tags = product.shop.tags || DEFAULT_TAGS
    if params[:tags].present?
      default_tags.concat(params[:tags].split(',')).uniq
    end
    default_tags
  end

  def set_shop
    @shop = params[:shop_id].present? ? Shop.find_by(id: params[:shop_id]) : nil
  end

  def fetch_products
    page = params[:page] || 1

    if @shop.present?
      @shop.products.order(:created_at).includes(:reviews).page(page).per(2)
    else
      Product.order(:created_at).includes(:reviews).page(page).per(2)
    end
  end

  def paginate_reviews_for_products(products)
    paginated_reviews = {}
    review_page = params[:review_page] || 1
    products.each do |product|
      paginated_reviews[product.id] = product.reviews.order(:created_at).page(review_page).per(3)
    end
    paginated_reviews
  end

  def paginate_reviews_for_product(product)
    review_page = params[:review_page] || 1
    product.reviews.order(:created_at).page(review_page).per(3)
  end
end
