Discuss::Engine.routes.draw do


  get 'message/compose', to: 'messages#new', as: :compose

  resources :messages, except: :index, path: 'message' do
    post 'reply', to: 'messages#reply', as: :reply
    post 'trash', to: 'messages#trash', as: :trash
  end

  post 'mailbox/empty_trash', to: 'mailboxes#empty_trash', as: :empty_trash
  get 'mailbox/:mailbox', to: 'mailboxes#show', as: :mailbox
  get 'mailbox/:mailbox/:id', to: 'messages#show', as: :mailbox_message

end
