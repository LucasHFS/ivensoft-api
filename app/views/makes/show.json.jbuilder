# frozen_string_literal: true

json.make do |json|
  json.partial! 'makes/make', make: @make
end
