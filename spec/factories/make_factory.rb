FactoryBot.define do
  factory :make do
    name { Faker::Commerce.product_name }

    organization
  end
end
