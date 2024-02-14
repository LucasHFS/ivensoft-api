# frozen_string_literal: true

class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :models do |t|
      t.string :name
      t.belongs_to :organization, null: false, foreign_key: true
      t.belongs_to :make, null: false, foreign_key: true

      t.timestamps
    end

    add_index :models, %i[name organization_id], unique: true
  end
end
