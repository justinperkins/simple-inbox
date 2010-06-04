class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.integer       :inbox_id
      t.integer       :uid
      t.string        :from
      t.string        :from_email
      t.string        :subject
      t.datetime      :read
      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
