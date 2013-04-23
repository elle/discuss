Discuss::Engine.routes.draw do

  get 'messages/:mailbox', to: 'messages#index'
  resources :messages
end
