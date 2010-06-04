# Copyright 2009-2010 Justin Perkins

# t.integer   :user_id
# t.string    :email
# t.string    :password # we need to be able to read these passwords later so we can't encrypt them
# t.datetime  :last_checked
# t.datetime  :inactive
# t.string    :preferences
# t.timestamps

class LinkedAccount < ActiveRecord::Base
  belongs_to :user
  has_many :inboxes, :dependent => :destroy
  has_many :emails, :through => :inboxes
  validates_presence_of :email, :password
  serialize :preferences, Hash

  # expose preferences with easy to use methods to simulate real attributes
  %w{ immediate_read forward_all }.each do |preference|
    class_eval <<-end_eval
      def #{ preference }?
        self.preferences[:#{ preference }]
      end
      def #{ preference }=(value)
        self.preferences[:#{ preference }] = value
      end
    end_eval
  end
  
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

  # so we can default preferences to an empty hash since the serialize method doesn't do that for us
  def preferences
    read_attribute(:preferences) || write_attribute(:preferences, {})
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