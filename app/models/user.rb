# Copyright 2009-2010 Justin Perkins

# t.string    :login
# t.string    :email
# t.string    :crypted_password
# t.string    :password_salt
# t.string    :persistence_token
# t.timestamps

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.require_password_confirmation = false
    c.validate_email_field = false
  end
  
  has_one :linked_account, :dependent => :destroy
  
  named_scope :with_email, :conditions => "email <> ''"
end
