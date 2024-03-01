# frozen_string_literal: true

FactoryBot.define do
  factory :vehicle do
    paid_price_in_cents { Faker::Number.decimal(l_digits: 2) }
    plate { Faker::Vehicle.license_plate }
    comments { Faker::Lorem.sentence }

    organization
    model
  end
end
