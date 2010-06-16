# Copyright 2009-2010 Justin Perkins
ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'intro', :action => 'redirect'
  map.resource :user_session, :as => 'sessions'
  map.resources :users, :as => 'accounts', :member => {:overview => :get}
  map.resources :linked_accounts, :member => {:activate => :post, :deactivate => :post}

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
