class CreateInboxRules < ActiveRecord::Migration
  def self.up
    create_table :inbox_rules do |t|
      t.string      :operation
      t.string      :description
      t.timestamps
    end
  end

  def self.down
    drop_table :inbox_rules
  end
end
