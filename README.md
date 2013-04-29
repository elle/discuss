# Discuss

We have a table discuss users that will be used to populate the recipients field.
We are not creating new users via recipients since the user need to exist and be logged in in order to view her messages.

If for example we have two users: Batman and Robin and Batman sends a message to Robin. What will be created are two objects:
1. A Message object where(discuss_user: Batman, sent_at: Time.zone.now)
2. A second MEssage object where(dicuss_user: Robin, received_at: Time.zone.now)

When Robin logs in, she can view this message in her inbox.
The inbox view user Mailbox.new(Robin).inbox

Batman's sent messages view will use a similar query:
Mailbox.new(user).outbox


If no recipients are entered, the message will be saved as draft.
Messages by default are sent as draft until they are delivered

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

The gem uses a current_user helper method that is usally provided with most authentication systems.
If you wish to use your own class, override our `current_discuss_user` method to use your own class.

```
  class ApplicationController < ActionController::Base

    private
    def current_user
      # Your own implementation
    end
  end
```

## Running the tests

```
  rake db:create && rake db:migrate
  rake db:migrate RAILS_ENV=test
  rake test
```

## TODO

* Views
* Review User class in app
* Markdown styling for message body
* Display conversations
* Mailers
* Config options to disbale or enable mailers
* Move message delivery and mailers to a background job
* Generator to copy views to parent project for customisation

This project rocks and uses MIT-LICENSE.
