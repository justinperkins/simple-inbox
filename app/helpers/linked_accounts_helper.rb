# Copyright 2009-2010 Justin Perkins
module LinkedAccountsHelper
  def feed_entry_content(email)
    content_tag(:p, "Subject: #{ h(email.subject) }") +
    content_tag(:p, "From: #{ h(email.from_email) }") +
    content_tag(:p, "Arrived: #{ email.arrived.strftime('%a %b %d, %Y at %H:%M') }")
  end
end
