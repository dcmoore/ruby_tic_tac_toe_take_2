Rails309::Application.routes.draw do
  root :to => "pages#new_game"
  match '/index', :to => 'pages#index'
  match '/review', :to => 'pages#review'
end
