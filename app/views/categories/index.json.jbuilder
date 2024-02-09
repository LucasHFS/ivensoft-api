# frozen_string_literal: true

json.categories do |json|
  json.array! @categories, partial: 'category', as: :category
end
