# frozen_string_literal: true

json.call(user, :id, :email)
json.token user.generate_jwt
json.organization user.organization.first.name
