Rails.application.routes.draw do
  resources :user_searches
  resources :hrefs
  resources :users

  get '/search', to: "nasas#search"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
