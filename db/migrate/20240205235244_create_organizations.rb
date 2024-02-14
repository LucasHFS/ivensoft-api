# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
