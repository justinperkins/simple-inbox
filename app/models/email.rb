# Copyright 2009-2010 Justin Perkins

# t.integer       :inbox_id
# t.integer       :uid
# t.string        :from
# t.string        :from_email
# t.string        :subject
# t.datetime      :arrived
# t.datetime      :read
# t.timestamps

class Email < ActiveRecord::Base
  belongs_to :inbox
  
  validates_presence_of :uid, :from_email
  
  named_scope :by_uid, lambda { |uid| {:conditions => {:uid => uid}} }
  named_scope :for_day, lambda { |day|
    {:conditions => {:arrived => (day.midnight)..day.midnight+1.day}}
  }

  before_create :stamp_arrived_if_blank
  
  def linked_account
    self.inbox.linked_account
  end

  private
  def stamp_arrived_if_blank
    self.arrived = Time.now if self.arrived.blank?
  end
end
