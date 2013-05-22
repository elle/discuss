# Discuss

We have a table discuss users that will be used to populate the recipients field.
We are not creating new users via recipients since the user need to exist and be logged in in order to view her messages.

If for example we have two users: Batman and Robin and Batman sends a message to Robin. What will be created are two objects:

1. A Message object `where(discuss_user: Batman, sent_at: Time.zone.now)`
2. A second Message object `where(dicuss_user: Robin, received_at: Time.zone.now)`

When Robin logs in, she can view this message in her inbox.
The inbox view uses `Mailbox.new(Robin).inbox`

Batman's sent messages view will use a similar query: `Mailbox.new(Batman).outbox`


If no recipients are entered, the message will be saved as draft.
Messages by default are saved as draft until they are delivered (#send!).

## Setup

Add the gem to your Gemfile.

```ruby
gem 'discuss'
```

Get the migrations

```shell
rake discuss:install:migrations
```

And run them on in your app

```shell
rake db:migrate
```

Add the following to `config/routes.rb`:

```ruby
mount Discuss::Engine, :at => '/messages'
```

Define a `current_user` in your `application_controller.rb`:

```ruby
class ApplicationController < ActionController::Base

    private
    def current_user
      # Your own implementation
    end
  end
end
```

Add the following to `user.rb`:

```ruby
class User < ActiveRecord::Base
  acts_as_discussable
end
```

And lastly add the following to your assets files:


```ruby
#app/assets/stylesheets/application.scss
@import "discuss/application";

#app/assets/javascripts/application.js
//= require discuss/application
```

If you have problems with your current routes, you might need to add `main_app` to the beginning of your routes.

And in our case, all the messages interface should be available at `/messages`

## DSL

```ruby
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

@message.reply!(body: 'awesome', subject: 'adjusted subject') # => replies to sender. only :body is really needed

# With conversation:
@conversation = Discuss::Conversation.new(@message, user) # => user defaults to message.user if not passed through
@conversation.all # => shows all the messages, owned or not by the user
@conversation.for_user # => shows only the messages the user owns
@conversation.trash_conversation! # => trashes messages in the conversation that the user owns
```

## User class

The User class has the following method:

```
  def to_s
    prefix
  end
```

In the gem, these two methods rely on having `first_name`, `last_name` or `email` attributes.
But you can override either method with your implementation.

If you wish to actually send out an email, then the User class will also need an `email`.

## Override the recipients collection

If you wish to be able to send messages only to people in your company, override the `discuss_recipients` helper method in your `application_controller.rb`.

```ruby
class ApplicationController < ActionController::Base
  private
  def discuss_recipients
    @recipients = current_company.users.reject { |u| u == discuss_current_user }
  end
  helper_method :discuss_recipients
end
```

## Configuring views

Since Discuss is an engine, all its views are packaged inside the gem. These views will help you get started.

If you wish to customise the views, you just need to invoke the following generator, and it will copy all views to your application:

```shell
rails generate discuss:views
```

## Running the tests

```shell
rake db:create && rake db:migrate
rake db:migrate RAILS_ENV=test
rake test
```

## TODO

* Add message attributes as classes
* Keep draft of unsaved message in local storage
* Display conversations
* Mailers
* Config options to disable or enable mailers
* Move message delivery and mailers to a background job

This project rocks and uses [MIT-LICENSE](MIT-LICENSE).
