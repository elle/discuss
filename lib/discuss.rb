require 'redcarpet'
require 'discuss/engine'
require 'discuss/models/discussable'

module Discuss
  class << self
    # Override the default base class all Discuss models inherit from.
    # This is useful if you want to inherit from an abstract class
    # that calls `connects_to`, for example.
    #
    # The default value is `ActiveRecord::Base`.
    #
    #     Discuss.model_base = ActiveRecord
    #
    # or
    #
    #     Discuss.model_base = MyOtherDatabase::ActiveRecord
    #
    # The default value is:
    #
    #     ActiveRecord::Base
    #
    attr_writer :model_base

    # Override the default message inbox scope:
    #
    #     Discuss.inbox_scope = -> (messages, user) {
    #       messages.by_user(user).active.received.my_filter
    #     }
    #
    # The default value is:
    #
    #     -> (messages, user) {
    #       messages.by_user(user).active.received
    #     }
    #
    attr_writer :inbox_scope

    # Override the default char limit on message length:
    #
    #     Discuss.maximum_message_body_chars = 2000
    #
    # The default value is:
    #
    #     Discuss.maximum_message_body_chars = 1200
    #
    attr_writer :maximum_message_body_chars

    def model_base
      defined?(@model_base) ? @model_base : ActiveRecord::Base
    end

    def inbox_scope
      defined?(@inbox_scope) ? @inbox_scope : -> (messages, user) { messages.by_user(user).active.received }
    end

    def maximum_message_body_chars
      defined?(@maximum_message_body_chars) ? @maximum_message_body_chars : 1200
    end
  end
end
