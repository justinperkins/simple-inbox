# Copyright 2009-2010 Justin Perkins
class DigestMailer < ActionMailer::Base
  helper :application
  default_url_options[:host] = 'simpleinbox.thenumber6.com'

  def daily(user, day, items = [])
    recipients(user.email)
    from("simpleinbox@thenumber6.com")
    subject("Simple Inbox Daily Digest for #{ day.strftime('%m/%d/%Y') }: #{ items.size } #{ items.size == 1 ? 'Email' : 'Emails' }")
    body(:user => user, :day => day, :items => items)
  end
end
