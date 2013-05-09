Discuss::Engine.routes.draw do


  get 'message/compose', to: 'messages#new', as: :compose

  resources :messages, except: :index, path: 'message'

  get 'mailbox/:mailbox', to: 'mailboxes#show', as: :mailbox

end
