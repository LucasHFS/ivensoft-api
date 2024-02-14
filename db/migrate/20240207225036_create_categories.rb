# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, unique: true, null: false
      t.text :description
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end

    add_index :categories, %i[name organization_id], unique: true
  end
end
