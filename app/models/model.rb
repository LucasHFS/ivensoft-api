class Model < ApplicationRecord
  belongs_to :organization
  belongs_to :make

  validates :name, presence: true, uniqueness: { scope: :organization_id }
end
