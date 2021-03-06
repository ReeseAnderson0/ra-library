Rails.application.routes.draw do
  get 'pages/home'
  devise_for :users
  resources :books

  root to: "pages#home"
  post "/", to: "pages#home", as: 'home_page'
  post "/user", to: "pages#user", as: 'show_user'
  get "/user", to: "pages#user"
  post "/log", to: "books#log", as: 'log_book'
  get "/log", to: "books#log"
  post "/books/new", to: "books#new", as: 'create_book'
  get "/books", to: "books#index", as: 'index_book'
  get "/books/:id/show", to: "books#show", as: 'show_book'
  get "/books/:id/history", to: "books#history", as: 'history_book'
  get "/books/:id/details", to: "books#details", as: 'details_book'
  get "/books/:id/borrow", to: "books#borrow", as: 'borrow_book'
  get "/books/:id/waitlist", to: "books#waitlist", as: 'waitlist_book'
  get "/books/:id/returnBook", to: "books#returnBook", as: 'returnBook_book'
  get "/books/:id/removeWaitlist", to: "books#removeWaitlist", as: 'removeWaitlist_book'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
