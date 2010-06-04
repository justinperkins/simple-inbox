# Copyright 2009-2010 Justin Perkins

# t.integer       :inbox_id
# t.integer       :uid
# t.string        :from
# t.string        :from_email
# t.string        :subject
# t.datetime      :read
# t.timestamps

class Email < ActiveRecord::Base
  belongs_to :inbox
  
  validates_presence_of :uid, :from_email
  
  def linked_account
    self.inbox.linked_account
  end
end