# Copyright 2009-2010 Justin Perkins

# t.integer       :inbox_id
# t.integer       :remote_identifier
# t.string        :from
# t.string        :from_email
# t.string        :subject
# t.datetime      :read
# t.timestamps

class Envelope < ActiveRecord::Base
  belongs_to :inbox
  
  validates_presence_of :remote_identifier, :from_email
  
  def linked_account
    self.inbox.linked_account
  end
end
