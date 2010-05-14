require 'test_helper'

class LinkedAccountTest < ActiveSupport::TestCase
  test "required fields" do
    account = LinkedAccount.create
    assert account.new_record?
    assert account.errors['email']
    assert account.errors['password']
    account.email = 'foo@bar.com'
    account.password = 'whatever'
    assert account.save
  end
  
  test "inactive accounts" do
    a1 = linked_accounts(:dudes_account)
    a2 = linked_accounts(:walters_account)
    assert a1.active?
    assert !a2.active?
    a2.inactive = nil
    assert a2.active?
  end
  
  test "preferences initializes correctly" do
    account = linked_accounts(:dudes_account)
    assert_nil account.read_attribute(:preferences)
    assert_equal Hash.new, account.preferences
  end
  
  test "mark as read preference" do
    a = linked_accounts(:walters_account)
    assert !a.immediate_read?
    a.immediate_read = true
    assert a.immediate_read?
  end
  
  test "pull all emails" do
    LinkedAccount.any_instance.expects(:pull).times(LinkedAccount.count)
    LinkedAccount.pull_all
  end
  
  test "pull for account" do
    account = linked_accounts(:dudes_account)
    account.expects(:process).with('e1')
    account.expects(:process).with('e2')
    account.expects(:process).with('e3')
    worker = mock('gmail worker')
    worker.expects(:inbox).returns(%w{ e1 e2 e3 })
    GmailWorker.expects(:new).yields(worker)
    account.pull
  end
  
  test "process envelope" do
    account = linked_accounts(:dudes_account)
    fake_envelope = mock('envelope')
    fake_envelope.expects(:inbox).returns('bowling')
    fake_inbox = mock('inbox')
    fake_inbox.expects(:new_record?).returns(false)
    fake_inbox.expects(:handle_incoming).with(fake_envelope)
    Inbox.expects(:find_or_create_by_label).with('bowling').returns(fake_inbox)
    account.process(fake_envelope)
  end

  test "process envelope with inbox creation failure" do
    account = linked_accounts(:dudes_account)
    fake_envelope = mock('envelope')
    fake_envelope.expects(:inbox).returns('bowling')
    fake_inbox = mock('inbox')
    fake_inbox.expects(:new_record?).returns(true)
    fake_inbox.expects(:handle_incoming).never
    fake_inbox.expects(:errors).returns(ActiveRecord::Errors.new('fake inbox'))
    Inbox.expects(:find_or_create_by_label).with('bowling').returns(fake_inbox)
    begin
      account.process(fake_envelope)
    rescue LinkedAccountError => ex
      assert_match /created an invalid inbox/i, ex.to_s
    end
  end
end
