# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Company.name }

    after(:create) do |organization|
      create(:deposit, organization:)
    end
  end
end
