# frozen_string_literal: true

FactoryBot.define do
  factory :deposit_product do
    quantity { 1 }

    product
    deposit
    organization
  end
end
