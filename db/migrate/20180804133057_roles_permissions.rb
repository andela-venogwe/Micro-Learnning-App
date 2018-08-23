class RolesPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :roles_permissions do |t|
      t.belongs_to :role, index: true
      t.belongs_to :permission, index: true
      t.integer :permission_id, null: false, :limit => 8
      t.integer :role_id, null: false, :limit => 8
    end
  end
end