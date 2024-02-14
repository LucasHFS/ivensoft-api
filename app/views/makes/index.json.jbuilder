# frozen_string_literal: true

json.makes do |json|
  json.array! @makes, partial: 'make', as: :make
end
