ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'users'
  map.resource :user_session, :as => 'sessions'
  map.resources :users, :as => 'accounts'
  map.resources :linked_accounts, :member => {:activate => :post, :deactivate => :post}

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
