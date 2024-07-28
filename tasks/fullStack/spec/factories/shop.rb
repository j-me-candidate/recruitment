FactoryBot.define do
  factory :shop do
    name { Faker::Company.name }
    tags { [Faker::Lorem.word, Faker::Lorem.word] }
  end
end
