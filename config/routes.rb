Rails.application.routes.draw do
  get '/' => 'home#index'
  post 'convert' => 'home#convert'
  get 'success' => 'home#success'
  get 'download' => 'home#download'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'home#index'
end
