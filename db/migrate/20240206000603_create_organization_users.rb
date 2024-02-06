class CreateOrganizationUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :organization_users do |t|
      t.belongs_to :organization
      t.belongs_to :user

      t.timestamps
    end
  end
end
