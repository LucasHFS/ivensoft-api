# frozen_string_literal: true

json.call(product, :id, :name, :sku, :comments)
json.modelId product.model_id
json.makeId product.model.make_id
json.categoryId product.category_id
json.salePrice product.sale_price
json.hideOnSale product.hide_on_sale
json.visibleOnCatalog product.visible_on_catalog
