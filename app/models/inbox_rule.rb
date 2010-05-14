# Copyright 2009-2010 Justin Perkins

class InboxRule < ActiveRecord::Base
  has_many :inboxes
  
  validates_presence_of :operation
end