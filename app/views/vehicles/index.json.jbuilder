# frozen_string_literal: true

json.vehicles do |json|
  json.array! @vehicles, partial: 'vehicle', as: :vehicle
end
