class TagService
  DEFAULT_TAGS = ['default']

  def self.tags_with_default(product_id, tags)
    product = Product.find_by(id: product_id)
    default_tags = (product&.shop&.tags || DEFAULT_TAGS).dup
    if tags.present?
      default_tags.concat(tags.split(',')).uniq
    end
    default_tags
  end
end
