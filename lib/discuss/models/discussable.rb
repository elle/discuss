module Discuss
  module Models
    module Discussable
      extend ActiveSupport::Concern

      module ActiveRecord
        # Converts the model into discussable allowing it to interchange messages
        def acts_as_discussable
          include Discussable
        end
      end

      included do
        has_many :messages, class_name: 'Discuss::Message'
      end

      def to_s
        full_name
      end

      def full_name
        "#{try(:first_name)} #{try(:last_name)}"
      end

      def prefix
        try(:full_name) || email
      end

      def message_title
        "#{prefix} <#{email}>"
      end
    end
  end
end


