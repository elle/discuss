Discuss::Engine.routes.draw do

  get 'messages/compose', to: 'messages#new', as: :compose

  resource :messages, except: :index do
    post 'save_draft', to: 'messages#save_draft', as: :save_draft
  end

  get 'mailbox/:mailbox', to: 'mailboxes#show', as: :mailbox

end
