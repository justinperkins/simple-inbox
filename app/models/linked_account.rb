# Copyright 2009-2010 Justin Perkins

# t.integer   :user_id
# t.string    :email
# t.string    :password # we need to be able to read these passwords later so we can't encrypt them
# t.datetime  :last_checked
# t.datetime  :inactive
# t.boolean   :immediate_read
# t.boolean   :forward_all
# t.timestamps

class LinkedAccount < ActiveRecord::Base
  belongs_to :user
  has_many :inboxes, :dependent => :destroy
  has_many :emails, :through => :inboxes
  validates_presence_of :email, :password

  def self.pull_all
    self.all.each { |a| a.pull }
  end
  
  def pull
    logger.info "processing inbox for user: #{ self.user.login } at #{ Time.now }"
    
    Gmail.new(self.email, self.password).inbox.emails(:after => self.last_checked).each do |email|
      process(email)
    end
    self.update_attributes(:last_checked => Time.now)
    logger.info "done processing inbox for user: #{ self.user.login } at #{ Time.now }"
    self
  end
  
  def active?
    self.inactive.nil?
  end
  
  def activate!
    self.inactive = nil
    self.save
  end
  
  def deactivate!
    self.inactive = Time.now
    self.save
  end

  def process(email)
    inbox = inboxes.find_or_create_by_label(extract_inbox_name(email))
    unless inbox.new_record?
      inbox.handle_incoming(email)
    else
      raise LinkedAccountError, "Created an invalid inbox (#{ inbox.errors.full_messages.to_sentence }) and could do nothing with the envelope: #{ email.inspect }"
    end
  end
  
  private
  def extract_inbox_name(email)
    email.to.gsub(/(@.*$)/, '')
  end
end

class LinkedAccountError < RuntimeError; end