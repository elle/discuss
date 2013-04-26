# Discuss

We have a table discuss users that will be used to populate the recipients field.
We are not creating new users via recipients since the user need to exist and be logged in in order to view her messages.

If for example we have two users: Batman and Robin and Batman sends a message to Robin. What will be created are two objects:
1. A Message object where(sender: Batman)
2. A MessageUser join where(dicuss_user: Robin)

When Robin logs in, she can view this message in her inbox.
The inbox view user User.find(Robin.id).received_massages

Batman's sent messages view will use a similar query:
User.find(Batman.id).sent_messages


If no recipients are entered, the message will be saved as draft.

## Setup

add the gem to your Gemfile.

```
  gem 'discuss'
```

get the migrations

```
  rake discuss:install:migrations
```

## Api

```
  @mailbox = Mailbox.new(user)
  @mailbox.inbox
  @mailbox.outbox
  @mailbox.drafts
  @mailbox.trash

  @mailbox.empty_trash! # => deletes all messages that are already trashed

  @message = User.message.create(body: 'lorem ipsum', recipients: [@user1, @user2]) # => creates a draft
  @message.send! # delivers a message

  @message.trash!   # => moves the message to the trash
  @message.delete!  # => removes message from all views
```


## Override current user

The gem uses a current_user helper method that is usally provided with most authentocation systems.
If you wish to use your own class, override our `current_discuss_user` method to use your own class.

```
  class ApplicationController < ActionController::Base

    private
    def current_discuss_user
      current_user
    end
  end
```

## TODO

* Markdown styling for message body
* Conversation
* Mailers

This project rocks and uses MIT-LICENSE.
