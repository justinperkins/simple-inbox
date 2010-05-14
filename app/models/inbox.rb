# Copyright 2009-2010 Justin Perkins

# t.integer   :linked_account_id
# t.string    :label
# t.integer   :rule_id
# t.datetime  :last_used
# t.timestamps

class Inbox < ActiveRecord::Base
  belongs_to :linked_account
  belongs_to :inbox_rule
  has_many :envelopes, :dependent => :destroy

  # allow the stop flag to be set/unset publicly
  attr_accessor :stop_processing

  validates_presence_of :label
  
  named_scope :by_label, lambda { |label|
    { :conditions => {:label => label} }
  }
  
  def handle_incoming(gmail_envelope)
    # quick exit if this envelope has been processed already
    return if envelopes.find_by_remote_identifier(gmail_envelope.remote_identifier)

    # get a local copy of the envelope attributes we'll use to create the new envelope
    # delete the inbox attribute off of this envelope since we don't care about it in this context
    envelope_attributes = gmail_envelope.attributes.reject { |k,v| k == :inbox }

    # give the before rules a chance to run, things like ignoring emails, auto-deleting them, etc
    # we're creating a new envelope so that our before_process filter can have an actual envelope object to work with
    # as opposed to this crazy gmail envelope that is passed in
    before_process(Envelope.new(envelope_attributes))
    
    # the before rules can set the stop flag which tells us not to do anything with the envelope
    unless stop?
      # now we want to save the envelope
      finalized_envelope = envelopes.create(envelope_attributes)
    end
    
    # now time for the after rules, such as forwarding to primary email, mark as read, etc
    after_process(finalized_envelope)
    
    # and lastly, update our usage time attribute
    record_usage
  end
  
  def before_process(envelope)
    # render any before rules
    # set a "stop what you're doing flag" if needed
    # @stop_processing = true
  end
  
  def after_process(envelope)
    # render any after rules
  end
  
  def record_usage
    self.last_used = Time.now
    self.save
  end
  
  def stop?
    @stop_processing
  end
end