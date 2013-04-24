Discuss::Engine.routes.draw do

  get 'messages/compose', to: 'messages#new', as: :compose
  get 'messages/:mailbox', to: 'messages#index', as: :mailbox
  resources :messages
end
