# frozen_string_literal: true

class CreateDeposits < ActiveRecord::Migration[7.0]
  def change
    create_table :deposits do |t|
      t.string :name

      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
