class AddMoreRulesToAccounts < ActiveRecord::Migration
  def self.up
    change_table :linked_accounts do |t|
      t.boolean :forward_new
      t.boolean :digest, :default => true
    end
  end

  def self.down
    change_table :linked_accounts do |t|
      t.remove :forward_new
      t.remove :digest
    end
  end
end