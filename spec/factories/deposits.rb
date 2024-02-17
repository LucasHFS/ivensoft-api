# frozen_string_literal: true

FactoryBot.define do
  factory :deposit do
    name { Faker::Name.name }

    organization
  end
end
