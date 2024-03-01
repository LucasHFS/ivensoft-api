# frozen_string_literal: true

json.vehicle do |json|
  json.partial! 'vehicles/vehicle', vehicle: @vehicle
end
