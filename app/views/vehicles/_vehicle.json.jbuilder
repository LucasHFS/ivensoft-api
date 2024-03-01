# frozen_string_literal: true

json.call(vehicle, :id, :plate, :comments)

# TODO: fix n+1 later
json.modelId vehicle.model_id
json.makeId vehicle.model.make_id

json.vehicleProducts vehicle.vehicle_products do |vehicle_product|
  json.productId vehicle_product.product_id
  json.name vehicle_product.product.name
  json.quantity vehicle_product.quantity
end
