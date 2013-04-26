require 'test_helper'

module Discuss
  class MessageTest < MiniTest::Spec
    it 'must be valid' do
      message = Message.new()
      refute message.valid?
      assert_equal 2, message.errors.count
    end

    it 'should have a user' do
      user = DiscussUser.create(name: 'homer', email: 'homer@simpsons.com')
      message = user.messages.new
      refute_nil message.discuss_user
    end

    it 'cannot go back to being a draft once sent'
    it 'cannot be edited once sent'
    it 'cannot be edited if recieved'
  end
end
