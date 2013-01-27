if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    resources :repeating_issues    
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :repeating_issues
  end
end
