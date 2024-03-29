# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    sku { Faker::Commerce.product_name.parameterize.underscore }
    hide_on_sale { false }
    visible_on_catalog { false }
    sale_price_in_cents { Faker::Number.number(digits: 5) }

    organization
    model
    category

    trait :with_deposit_products do
      after(:create) do |product|
        product.deposit_products.create(deposit: product.organization.default_deposit)
      end
    end
  end
end
