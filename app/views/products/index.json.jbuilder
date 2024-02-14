# frozen_string_literal: true

json.products do |json|
  json.array! @products, partial: 'product', as: :product
end
