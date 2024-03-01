# frozen_string_literal: true

class VehicleProduct < ApplicationRecord
  belongs_to :vehicle
  belongs_to :product
end
