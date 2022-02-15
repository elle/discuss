module Discuss
  module Models
    module Discussable
      # Converts the model into discussable allowing it to interchange messages
      def self.included(klass)
        klass.include(InstanceMethods)
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_discussable
          has_many :messages, class_name: 'Discuss::Message', as: :user
        end
      end

      module InstanceMethods
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
end
