# frozen_string_literal: true

json.deposits do |json|
  json.array! @deposits, partial: 'deposit', as: :deposit
end
