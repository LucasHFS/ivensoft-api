# frozen_string_literal: true

class Vehicle < ApplicationRecord
  belongs_to :model
  belongs_to :organization

  has_many :vehicle_products, dependent: :destroy
  has_many :products, through: :vehicle_products

  validates :plate, presence: true, uniqueness: true
end
