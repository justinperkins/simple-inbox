# Copyright 2009-2010 Justin Perkins

cache("account/feed/#{ current_user.linked_account.cache_key }") do
  atom_feed do |feed|
    feed.title("Your Simple Inbox Feed")
    feed.updated(current_user.linked_account.updated_at)

    current_user.linked_account.emails.by_arrived.scoped(:limit => 200).each do |email|
      feed.entry(email, :published => email.arrived, :url => root_url(:only_path => false)) do |entry|
        entry.title(email.subject)
        entry.content(feed_entry_content(email), :type => 'html')
        entry.updated(email.arrived)
        entry.author do |author|
          author.name(email.from_email)
        end
      end
    end
  end
end