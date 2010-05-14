class CreateInboxes < ActiveRecord::Migration
  def self.up
    create_table :inboxes do |t|
      t.integer   :linked_account_id
      t.string    :label
      t.integer   :rule_id
      t.datetime  :last_used
      t.timestamps
    end
  end

  def self.down
    drop_table :inboxes
  end
end
