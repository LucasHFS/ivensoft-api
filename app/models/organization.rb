class Organization < ApplicationRecord
  has_many :organization_users, dependent: :destroy
  has_many :users, through: :organization_users
  has_many :categories, dependent: :destroy

  validates :name, presence: true
end
