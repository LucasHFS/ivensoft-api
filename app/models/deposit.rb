# frozen_string_literal: true

class Deposit < ApplicationRecord
  belongs_to :organization
  has_many :deposit_products, dependent: :destroy
  has_many :products, through: :deposit_products
  has_many :transactions, dependent: :destroy

  validates :name, presence: true
end
