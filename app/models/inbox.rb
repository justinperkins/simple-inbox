# Copyright 2009-2010 Justin Perkins

# t.integer   :linked_account_id
# t.string    :label
# t.integer   :rule_id
# t.datetime  :last_used
# t.timestamps

class Inbox < ActiveRecord::Base
  belongs_to :linked_account
  belongs_to :inbox_rule
  has_many :emails, :dependent => :destroy

  # allow the stop flag to be set/unset publicly
  attr_accessor :stop_processing

  validates_presence_of :label
  
  named_scope :by_label, lambda { |label|
    { :conditions => {:label => label} }
  }
  
  def handle_incoming(incoming_email)
    # quick exit if this email has been processed already
    return true if emails.by_uid(incoming_email.uid).count > 0

    arrived = if incoming_email.received.is_a?(Array) then incoming_email.received.first.date_time
    else incoming_email.received.date_time
    end
    email_attrs = {:uid => incoming_email.uid, :from => incoming_email.from.first, :from_email => incoming_email.from.first, :subject => incoming_email.subject, :arrived => arrived}

    # give the before rules a chance to run, things like ignoring emails, auto-deleting them, etc
    # we're creating a new envelope so that our before_process filter can have an actual envelope object to work with
    # as opposed to this crazy gmail envelope that is passed in
    before_process(Email.new(email_attrs))
    
    # the before rules can set the stop flag which tells us not to do anything with the envelope
    unless stop?
      # now we want to save the envelope
      finalized_email = emails.create(email_attrs)
    end
    
    # now time for the after rules, such as forwarding to primary email, mark as read, etc
    after_process(finalized_email)
    
    # and lastly, update our usage time attribute
    record_usage
  end
  
  def before_process(email)
    # render any before rules
    # set a "stop what you're doing flag" if needed
    # @stop_processing = true
  end
  
  def after_process(email)
    # render any after rules
    if self.linked_account.forward_new?
      # forward this email to the user's primary account
    end
  end
  
  def record_usage
    self.last_used = Time.now
    self.save
  end
  
  def stop?
    @stop_processing
  end
end