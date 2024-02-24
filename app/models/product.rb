# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :model
  belongs_to :category
  belongs_to :organization

  validates :sku, presence: true, uniqueness: { scope: :organization_id }
  validates :name, presence: true

  has_many :deposit_products, dependent: :destroy
  has_many :deposits, through: :deposit_products

  after_create :create_deposit_product!

  def sale_price
    sale_price_in_cents.to_f / 100.0
  end

  private

  def create_deposit_product!
    organization.default_deposit.deposit_products.create!(product: self)
  end
end
