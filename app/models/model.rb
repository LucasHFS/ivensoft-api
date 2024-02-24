# frozen_string_literal: true

class Model < ApplicationRecord
  # TODO: remove organization
  belongs_to :organization
  belongs_to :make

  validates :name, presence: true, uniqueness: { scope: :organization_id }
end
