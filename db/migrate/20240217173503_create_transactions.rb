# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type, default: 0
      t.integer :quantity
      t.datetime :transactioned_at

      t.belongs_to :deposit, null: false
      t.belongs_to :organization, null: false
      t.belongs_to :product, null: false

      t.timestamps
    end
  end
end
