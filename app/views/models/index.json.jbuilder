# frozen_string_literal: true

json.models do |json|
  json.array! @models, partial: 'model', as: :model
end
