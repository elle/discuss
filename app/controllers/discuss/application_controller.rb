module Discuss
  class ApplicationController < ::ApplicationController
    before_action :discuss_current_user

    private

    def discuss_current_user
      current_user
    end
    helper_method :discuss_current_user

    def recipients
      (discuss_recipients || recipient_objects).reject { |u| u == discuss_current_user }
    end
    helper_method :recipients

    # For example `set_flash_message :notice, :trash_emptied`
    def set_flash_message(key, kind, options = {})
      message = find_message(kind, options)
      flash[key] = message if message.present?
    end

    def find_message(kind, options = {})
      I18n.t("discuss.#{controller_name}.#{kind}", options)
    end

    private

    def recipient_objects
      recipient_classes.map { |c| c.all }.flatten
    end

    def recipient_classes
      ActiveRecord::Base.descendants.select { |c| c.included_modules.include? Discuss::Models::Discussable }
    end

    def recipient_json(r)
      Discuss::RecipientSerializer.new(r).to_hash.to_json
    end
    helper_method :recipient_json

    def recipient_from_json(json)
      Discuss::RecipientSerializer.from_hash(JSON.parse(json)).recipient
    end
  end
end
