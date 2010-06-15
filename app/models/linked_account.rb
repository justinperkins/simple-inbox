# Copyright 2009-2010 Justin Perkins

# t.integer   :user_id
# t.string    :email
# t.string    :password # we need to be able to read these passwords later so we can't encrypt them
# t.datetime  :last_checked
# t.datetime  :inactive
# t.boolean   :immediate_archive
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
    return if self.inactive
    logger.info "processing inbox for user: #{ self.user.login } at #{ Time.now } with last updated value #{ last_checked.to_s }"

    Gmail.new(self.email, self.password).inbox.emails(:unread).each do |email|
      inbox = process(email)
      if inbox && !inbox.new_record?
        email.label!(inbox.label)
        email.archive! if self.immediate_archive?
      else
        logger.info "failed when processing email: #{ email.inspect }"
        logger.info "related inbox: #{ inbox.inspect }"
        logger.info "skipping ahead ..."
      end
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
    logger.debug "processing email: #{ email.inspect }"
    begin
      inbox = inboxes.find_or_create_by_label(extract_inbox_name(email))
      inbox.handle_incoming(email)
      inbox
    rescue => ex
      logger.info "failed processing email: #{ ex.backtrace.join("\n") }"
      return false
    end
  end
  
  private
  def extract_inbox_name(email)
    email = email.header.fields.select { |f| f.name == 'Delivered-To' }.first.value.to_s
    logger.debug "extracting inbox from to: #{ email }"
    email ? email.gsub(/(@.*$)/, '') : '_unknown_'
  end
end

class LinkedAccountError < RuntimeError; end