require 'test_helper'

require 'gmail_worker'

class InboxTest < ActiveSupport::TestCase
  test "handle basic incoming email" do
    inbox = inboxes(:hello_box)
    email = build_email
    assert_difference "inbox.emails.count", 1 do
      inbox.handle_incoming(email)
    end
  end
  
  test "handle incoming email that has already been processed" do
    inbox = inboxes(:hello_box)
    email = build_email
    # set the remote identifier to something we're already using
    email.uid = inbox.emails.first.uid
    assert_difference "inbox.emails.count", 0 do
      inbox.handle_incoming(email)
    end
  end
  
  test "handle basic incoming email invokes before rules" do
    inbox = inboxes(:hello_box)
    email = build_email
    inbox.expects(:before_process)
    inbox.handle_incoming(email)
  end

  test "handle basic incoming email invokes after rules" do
    inbox = inboxes(:hello_box)
    email = build_email
    inbox.expects(:after_process)
    inbox.handle_incoming(email)
  end

  test "handle incoming email with before rules" do
    # not implemented yet
  end
  
  test "handle incoming email with after rules" do
    # not implemented yet
  end
  
  test "handle incoming email with before and after rules" do
    # not implemented yet
  end
  
  test "before processing" do
    # not implemented yet
  end
  
  test "before processing with email halting" do
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

    email = build_email
    assert_difference "inbox.emails.count", 0 do
      inbox.handle_incoming(email)
    end
  end
  
  private
  def build_email
    mail = Struct.new(:from, :subject, :uid)
    mail.new('dude@lebowski.com', 'Will you abide?', Time.now.to_i)
  end
end
