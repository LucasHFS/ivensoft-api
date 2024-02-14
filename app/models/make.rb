class Make < ApplicationRecord
  belongs_to :organization
  has_many :models, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :organization_id }
end
