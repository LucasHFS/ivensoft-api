class Product < ApplicationRecord
  belongs_to :model
  belongs_to :category
  belongs_to :organization

  validates :sku, presence: true, uniqueness: { scope: :organization_id }
  validates :name, presence: true

  def sale_price
    sale_price_in_cents.to_f / 100.0
  end
end
