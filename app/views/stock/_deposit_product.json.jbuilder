# frozen_string_literal: true

json.id deposit_product.product.id
json.name deposit_product.product.name
json.salePrice deposit_product.product.sale_price
json.balance deposit_product.quantity
json.totalSalePrice deposit_product.quantity * deposit_product.product.sale_price
