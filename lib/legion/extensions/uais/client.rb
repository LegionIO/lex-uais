# frozen_string_literal: true

module Legion
  module Extensions
    module Uais
      class Client
        include Helpers::Client
        include Runners::Registration

        attr_reader :opts

        def initialize(base_url: nil, api_key: nil, timeout: 30, mock: nil, **extra)
          mock = base_url.nil? if mock.nil?
          @opts = { base_url: base_url, api_key: api_key, timeout: timeout, mock: mock, **extra }
        end

        def settings
          { options: @opts }
        end
      end
    end
  end
end
