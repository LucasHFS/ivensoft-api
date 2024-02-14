class CreateMakes < ActiveRecord::Migration[7.0]
  def change
    create_table :makes do |t|
      t.string :name
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end

    add_index :makes, %i[name organization_id], unique: true
  end
end
