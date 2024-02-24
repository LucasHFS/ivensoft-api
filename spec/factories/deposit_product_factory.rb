# frozen_string_literal: true

FactoryBot.define do
  factory :deposit_product do
    quantity { Faker::Number.number(digits: 3) }

    deposit
    product
  end
end
