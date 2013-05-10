Discuss::Engine.routes.draw do


  get 'message/compose', to: 'messages#new', as: :compose

  resources :messages, except: :index, path: 'message' do
    post 'reply', to: 'messages#reply', as: :reply
    post 'trash', to: 'messages#trash', as: :trash
  end

  get 'mailbox/:mailbox', to: 'mailboxes#show', as: :mailbox

end
