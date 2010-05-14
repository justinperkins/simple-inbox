# Copyright 2009-2010 Justin Perkins

require 'net/imap'

class GmailEnvelope
  attr_accessor :remote_identifier, :inbox, :from, :from_email, :subject
  def initialize(remote_identifier, envelope = nil)
    @remote_identifier = remote_identifier
    return unless envelope

    @inbox = envelope.to && envelope.to.is_a?(Array) ? envelope.to[0].mailbox : '__unknown__'
    @from_email = envelope.from && envelope.from.is_a?(Array) ? "#{ envelope.from[0].mailbox }@#{ envelope.from[0].host }" : 'noreply@nohost.com'
    @from = envelope.from && envelope.is_a?(Array) ? envelope.from[0].name : @sender_email
    @subject = envelope.subject || 'no subject'
  end
  
  def update(options = {})
    options.delete_if { |k,v| !%w{ remote_identifier inbox from from_email subject }.include?(k.to_s) }
    options.keys.each { |k| self.send("#{ k }=", options[k])}
    return self
  end
  
  def attributes
    {
      :remote_identifier => @remote_identifier,
      :inbox => @inbox,
      :from => @from,
      :from_email => @from_email,
      :subject => @subject
    }
  end
  
  def self.valid?(envelope)
    envelope && envelope.message_id
  end
end

class GmailWorker
  attr_reader :connection
  def initialize(user, pass, options = {})
    @logger = options[:logger]
    log "establishing connection"
    @connection = connect
    log "logging in"
    @connection.login(user, pass)
    yield self
    log "disconnecting"
    disconnect
  end
  
  def login(user, pass)
    return unless open_connection?
    @connection.login(user, pass)
  end
  
  def logout
    @connection.logout if open_connection?
  end
  
  def inbox
    log "selecting INBOX"
    @connection.select('INBOX')
    log "searching for messages"
    @connection.search(['NOT', 'RECENT']).collect do |message_id|
      log "fetching envelope for message: #{ message_id }"
      envelope = @connection.fetch(message_id, 'ENVELOPE')[0].attr['ENVELOPE']
      log "found envelope: #{ envelope.inspect }"
      if GmailEnvelope.valid?(envelope)
        uid = @connection.uid_search(['HEADER', 'Message-ID', envelope.message_id])[0]
        GmailEnvelope.new(uid, envelope)
      else
        log "failed to find envelope for message: #{ message_id }", :info
        log "envelope: #{ envelope.inspect }", :info
      end
    end
  end

  private
  def valid_envelope?(envelope)
    envelope && envelope.message_id
  end
  
  def log(message, level = :debug)
    @logger.send(level, message) if @logger
  end
  
  def disconnect
    @connection.logout if open_connection?
  end
  
  def open_connection?
    @connection && !@connection.disconnected?
  end
  
  def connect
    Net::IMAP.new('imap.gmail.com', '993', true)
  end
end