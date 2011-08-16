Rails309::Application.routes.draw do
  root :to => "pages#index"
  match '/review', :to => 'pages#review'
end
