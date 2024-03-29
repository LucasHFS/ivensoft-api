# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    description { Faker::Lorem.sentence }
    organization
  end
end
