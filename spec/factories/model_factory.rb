FactoryBot.define do
  factory :model do
    name { Faker::Commerce.product_name }

    organization
    make
  end
end
