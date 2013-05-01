Discuss::Engine.routes.draw do


  get 'message/compose', to: 'messages#new', as: :compose

  resources :messages, except: :index, path: 'message' do
    post 'save_draft', to: 'messages#save_draft', as: :save_draft
  end

  get 'mailbox/:mailbox', to: 'mailboxes#show', as: :mailbox

end
