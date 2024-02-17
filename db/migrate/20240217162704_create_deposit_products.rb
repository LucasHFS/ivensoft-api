# frozen_string_literal: true

class CreateDepositProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :deposit_products do |t|
      t.integer :quantity, default: 0

      t.belongs_to :product, null: false
      t.belongs_to :deposit, null: false
      t.belongs_to :organization, null: false

      t.timestamps
    end
  end
end
