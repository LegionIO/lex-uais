# frozen_string_literal: true

require 'net/http'
require 'uri'

module Legion
  module Extensions
    module Uais
      module Helpers
        module Client
          def connection(base_url:, api_key: nil, timeout: 30, **_opts)
            uri = URI.parse(base_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = uri.scheme == 'https'
            http.open_timeout = timeout
            http.read_timeout = timeout
            http.instance_variable_set(:@_api_key, api_key)

            def http.api_key
              @_api_key # rubocop:disable ThreadSafety/ClassInstanceVariable
            end

            http
          end

          def build_request(method, path, body: nil, api_key: nil)
            klass = case method.to_s.downcase
                    when 'post'   then Net::HTTP::Post
                    when 'put'    then Net::HTTP::Put
                    when 'get'    then Net::HTTP::Get
                    when 'delete' then Net::HTTP::Delete
                    else
                      raise ArgumentError, "unsupported HTTP method: #{method}"
                    end

            req = klass.new(path)
            req['Content-Type'] = 'application/json'
            req['Authorization'] = "Bearer #{api_key}" if api_key
            req.body = Legion::JSON.dump(body) if body # rubocop:disable Legion/HelperMigration/DirectJson
            req
          end
        end
      end
    end
  end
end
