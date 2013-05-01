Discuss::Engine.routes.draw do


  resources :messages, except: :index, path: 'message' do
    get 'compose',     to: 'messages#new', as: :compose
    post 'save_draft', to: 'messages#save_draft', as: :save_draft
  end

  get 'mailbox/:mailbox', to: 'mailboxes#show', as: :mailbox

end
