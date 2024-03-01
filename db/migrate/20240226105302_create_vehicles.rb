# frozen_string_literal: true

class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :plate, index: { unique: true }
      t.text :comments

      t.belongs_to :model, null: false
      t.references :organization, null: false
      t.timestamps
    end
  end
end
