class UpdateLinkedAccountPreferences < ActiveRecord::Migration
  def self.up
    remove_column :linked_accounts, :immediate_read
    add_column :linked_accounts, :immediate_archive, :boolean, :default => true
  end

  def self.down
    add_column :linked_accounts, :immediate_read, :boolean, :default => false
    remove_column :linked_accounts, :immediate_archive
  end
end
