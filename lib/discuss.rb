require 'redcarpet'
require 'discuss/engine'
require 'discuss/models/discussable'

module Discuss
  class << self
    attr_writer :model_base

    def model_base
      if defined?(@model_base)
        @model_base
      else
        ActiveRecord::Base
      end
    end
  end
end
