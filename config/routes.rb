Rails.application.routes.draw do
  get 'pages/home'
  devise_for :users
  resources :books

  root to: "pages#home"
  get "/user", to: "pages#user", as: 'show_user'
  get "/log", to: "books#log", as: 'log_book'
  get "/books/:id/show", to: "books#show", as: 'show_book'
  get "/books/:id/details", to: "books#details", as: 'details_book'
  get "/books/:id/borrow", to: "books#borrow", as: 'borrow_book'
  get "/books/:id/returnBook", to: "books#returnBook", as: 'returnBook_book'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
