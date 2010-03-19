class CreateRestrictedPagePermissions < ActiveRecord::Migration
  def self.up
    create_table :restricted_page_permissions, :id => false do |t|
      t.references :restricted_page
      t.references :user
    end
  end

  def self.down
    drop_table :restricted_page_permissions
  end
end
