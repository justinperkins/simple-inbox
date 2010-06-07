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
  
  test "instant archive preference" do
    a = linked_accounts(:walters_account)
    assert a.immediate_archive?
    a.immediate_archive = false
    assert !a.immediate_archive?
  end

  test "forward all preference" do
    a = linked_accounts(:walters_account)
    assert !a.forward_all?
    a.forward_all = true
    assert a.forward_all?
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

    gmail = mock('gmail')
    inbox = mock('gmail inbox')
    inbox.expects(:emails).with(:unread).returns(%w{ e1 e2 e3 })
    gmail.expects(:inbox).returns(inbox)
    Gmail.expects(:new).with(account.email, account.password).returns(gmail)

    account.pull
  end
  
  test "pulling emails does labeling" do
  end
  
  test "pulling emails does archive when enabled" do
  end
  
  test "pulling emails skips archive when disabled" do
  end
  
  test "process envelope" do
    account = linked_accounts(:dudes_account)
    fake_envelope = mock('envelope')
    fake_inbox = mock('inbox')
    LinkedAccount.any_instance.expects(:extract_inbox_name).with(fake_envelope).returns('bowling')
    fake_inbox.expects(:handle_incoming).with(fake_envelope)
    Inbox.expects(:find_or_create_by_label).with('bowling').returns(fake_inbox)
    account.process(fake_envelope)
  end
end
