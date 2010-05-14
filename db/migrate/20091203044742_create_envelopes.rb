class CreateEnvelopes < ActiveRecord::Migration
  def self.up
    create_table :envelopes do |t|
      t.integer       :inbox_id
      t.integer       :remote_identifier
      t.string        :from
      t.string        :from_email
      t.string        :subject
      t.datetime      :read
      t.timestamps
    end
  end

  def self.down
    drop_table :envelopes
  end
end
