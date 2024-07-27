FactoryBot.define do
  factory :review do
    body { Faker::Lorem.paragraph }
    tags { [Faker::Lorem.word, Faker::Lorem.word]}
    reviewer_name { Faker::Name.name }
    rating { rand(1..5) }
  end
end
