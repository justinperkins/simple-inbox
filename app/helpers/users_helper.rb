# Copyright 2009-2010 Justin Perkins
module UsersHelper
  def link_to_edit_or_new_linked_account(user)
    if user.linked_account
     link_to('edit', edit_linked_account_path)
   else
     link_to('setup', new_linked_account_path)
   end
  end
end
