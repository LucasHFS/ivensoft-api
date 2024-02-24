# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :deposit
  belongs_to :product
  belongs_to :organization

  enum transaction_type: { input: 0, output: 1 }

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :transactioned_at, presence: true

  after_create :update_product_quantity

  private

  def update_product_quantity
    deposit_product = product.deposit_products.find_by(deposit:)

    if input?
      deposit_product.update!(quantity: deposit_product.quantity + quantity)
    else
      deposit_product.update!(quantity: deposit_product.quantity - quantity)
    end
  end
end
