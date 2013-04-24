Discuss::Engine.routes.draw do

  get 'messages/compose', to: 'messages#new', as: :compose
  resources :messages
  get 'mailbox/:mailbox', to: 'messages#index', as: :mailbox
end
