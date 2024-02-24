# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    transactioned_at { Time.zone.now }
    quantity { 1 }
    transaction_type { :input }

    product
    deposit
    organization
  end
end
