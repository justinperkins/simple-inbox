class AddEmailArrived < ActiveRecord::Migration
  def self.up
    add_column :emails, :arrived, :datetime
    Email.reset_column_information
    Email.all.each do |email|
      email.update_attributes(:arrived => email.created_at)
    end
  end

  def self.down
    remove_column :emails, :arrived
  end
end
