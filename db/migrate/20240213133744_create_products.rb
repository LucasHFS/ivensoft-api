# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :sku, null: false
      t.boolean :hide_on_sale, default: false
      t.boolean :visible_on_catalog, default: false
      t.integer :sale_price_in_cents, default: 0, null: false
      t.text :comments

      t.belongs_to :category, null: false, foreign_key: true
      t.belongs_to :model, null: false, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end

    add_index :products, %i[organization_id sku], unique: true
  end
end
