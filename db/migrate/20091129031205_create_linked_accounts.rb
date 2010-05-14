class CreateLinkedAccounts < ActiveRecord::Migration
  def self.up
    create_table :linked_accounts do |t|
      t.integer   :user_id
      t.string    :email
      t.string    :password # we need to be able to read these passwords later so we can't encrypt them
      t.datetime  :last_checked
      t.datetime  :inactive
      t.string    :preferences
      
      t.timestamps
    end
  end

  def self.down
    drop_table :linked_accounts
  end
end
