module Discuss
  class RecipientSerializer
    attr_reader :recipient

    def self.from_hash(hash)
      hash = hash.with_indifferent_access
      self.new(hash[:type].constantize.find(hash[:id]))
    end

    def initialize(recipient)
      self.recipient = recipient
    end

    def to_hash
      {type: recipient.class.to_s, id: recipient.id}
    end

    private

    attr_writer :recipient
  end
end
