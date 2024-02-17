# frozen_string_literal: true

class Deposit < ApplicationRecord
  belongs_to :organization
  has_many :deposit_products, dependent: :destroy
  has_many :products, through: :deposit_products

  validates :name, presence: true
end
