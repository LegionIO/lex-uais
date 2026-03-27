# frozen_string_literal: true

require 'legion/extensions/uais/version'
require 'legion/extensions/uais/helpers/client'
require 'legion/extensions/uais/runners/registration'

module Legion
  module Extensions
    module Uais
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core

      def self.default_settings
        {
          options: {
            base_url: nil,
            api_key:  nil,
            mock:     true,
            timeout:  30
          }
        }
      end
    end
  end
end
