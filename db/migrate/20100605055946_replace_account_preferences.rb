class ReplaceAccountPreferences < ActiveRecord::Migration
  def self.up
    remove_column :linked_accounts, :preferences
    add_column :linked_accounts, :immediate_read, :boolean, :default => true
    add_column :linked_accounts, :forward_all, :boolean, :default => false
  end

  def self.down
    add_column :linked_accounts, :preferences, :string
    remove_column :linked_accounts, :immediate_read
    remove_column :linked_accounts, :forward_all
  end
end
