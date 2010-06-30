# Copyright 2009-2010 Justin Perkins
module LinkedAccountsHelper
  def feed_entry_content(email)
    content_tag(:p, "Subject: #{ h(email.subject) }") +
    content_tag(:p, "Mailbox: #{ h(email.inbox.label) }") +
    content_tag(:p, "From: #{ h(email.from_email) }")
  end
end
