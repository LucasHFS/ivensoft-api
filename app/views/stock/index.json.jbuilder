# frozen_string_literal: true

json.products do |json|
  json.array! @deposit_products, partial: 'deposit_product', as: :deposit_product
end
