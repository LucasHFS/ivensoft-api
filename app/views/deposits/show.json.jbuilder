# frozen_string_literal: true

json.deposit do |json|
  json.partial! 'deposits/deposit', deposit: @deposit
end
