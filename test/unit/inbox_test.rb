require 'test_helper'

require 'gmail_worker'

class InboxTest < ActiveSupport::TestCase
  test "handle basic incoming envelope" do
    inbox = inboxes(:hello_box)
    envelope = build_envelope
    assert_difference "inbox.envelopes.count", 1 do
      inbox.handle_incoming(envelope)
    end
  end
  
  test "handle incoming envelope that has already been processed" do
    inbox = inboxes(:hello_box)
    envelope = build_envelope
    # set the remote identifier to something we're already using
    envelope.update(:remote_identifier => inbox.envelopes.first.remote_identifier)
    assert_difference "inbox.envelopes.count", 0 do
      inbox.handle_incoming(envelope)
    end
  end
  
  test "handle basic incoming envelope invokes before rules" do
    inbox = inboxes(:hello_box)
    envelope = build_envelope
    inbox.expects(:before_process)
    inbox.handle_incoming(envelope)
  end

  test "handle basic incoming envelope invokes after rules" do
    inbox = inboxes(:hello_box)
    envelope = build_envelope
    inbox.expects(:after_process)
    inbox.handle_incoming(envelope)
  end

  test "handle incoming envelope with before rules" do
    # not implemented yet
  end
  
  test "handle incoming envelope with after rules" do
    # not implemented yet
  end
  
  test "handle incoming envelope with before and after rules" do
    # not implemented yet
  end
  
  test "before processing" do
    # not implemented yet
  end
  
  test "before processing with envelope halting" do
    # not implemented yet
  end
  
  test "before processing with instant mark as read" do
    # not implemented yet
  end
  
  test "after processing" do
    # not implemented yet
  end
  
  test "after processing with email forwarding" do
    # not implemented yet
  end
  
  test "after processing with mark as read" do
    # not implemented yet
  end
  
  test "record usage" do
    inbox = inboxes(:hello_box)
    inbox.expects(:last_used=)
    inbox.expects(:save)
    inbox.record_usage
  end
  
  test "test stop flag" do
    inbox = inboxes(:hello_box)
    inbox.stop_processing = true # force the stop flag, hacky test

    envelope = build_envelope
    assert_difference "inbox.envelopes.count", 0 do
      inbox.handle_incoming(envelope)
    end
  end
  
  private
  def build_envelope
    GmailEnvelope.new(Time.now.to_i).update({
      :inbox => 'dude', 
      :from => 'jeff lebowski', 
      :from_email => 'dude@lebowski.com', 
      :subject => 'Will you abide?'
    })
  end
end
