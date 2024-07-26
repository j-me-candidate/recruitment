FactoryBot.define do
  factory :product do
    shop
    title { Faker::Commerce.product_name }
  end
end
