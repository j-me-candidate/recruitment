FactoryBot.define do
  factory :product do
    shop
    title { Faker::Commerce.product_name }

    trait :with_6_reviews do
      after(:create) do |product|
        create_list(:review, 6, product: product)
      end
    end
  end
end
