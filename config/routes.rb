Discuss::Engine.routes.draw do

  get 'messages/:mailbox', to: 'messages#index', as: :mailbox
  get 'messages/compose', to: 'messages#new', as: :compose
  resources :messages
end
