# frozen_string_literal: true

require 'bundler/setup'

# Minimal stubs for Legion framework modules used by lex-uais
module Legion
  module Extensions
    module Helpers
      module Lex; end
    end
  end

  module Logging
    def self.warn(msg); end
    def self.info(msg); end
    def self.debug(msg); end
  end

  module Settings
    def self.[](_key)
      nil
    end

    def self.dig(*_keys)
      nil
    end

    def self.merge_settings(key, defaults); end
  end

  module JSON
    def self.dump(obj)
      require 'json'
      ::JSON.generate(obj)
    end

    def self.load(str)
      require 'json'
      ::JSON.parse(str, symbolize_names: true)
    end
  end
end

require 'legion/extensions/uais'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
