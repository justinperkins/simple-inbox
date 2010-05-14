InboxRule.create([
  {:operation => 'trash', :description => 'instantly trash it'},
  {:operation => 'leave', :description => 'leave it alone'},
  {:operation => 'read', :description => 'instantly mark as read'},
  {:operation => 'spam', :description => 'mark as spam'},
  {:operation => 'forward', :description => 'forward to primary email (and mark as read)'}
])