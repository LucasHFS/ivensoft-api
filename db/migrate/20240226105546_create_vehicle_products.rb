# frozen_string_literal: true

class CreateVehicleProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicle_products do |t|
      t.integer :quantity, default: 1, null: false

      t.belongs_to :product, null: false
      t.belongs_to :vehicle, null: false

      t.timestamps
    end
  end
end
