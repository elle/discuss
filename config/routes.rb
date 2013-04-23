Discuss::Engine.routes.draw do

  get 'messages/:mailbox', to: 'messages#index'
  get 'messages/compose', to: 'messages#new'
  resources :messages
end
