# frozen_string_literal: true

FactoryBot.define do
  factory :vehicle_product do
    quantity { Faker::Number.decimal(l_digits: 2) }

    vehicle
    product
  end
end
