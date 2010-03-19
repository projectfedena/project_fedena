
ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'user', :action => 'login'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id/:id2'
  map.connect ':controller/:action/:id.:format'

end
