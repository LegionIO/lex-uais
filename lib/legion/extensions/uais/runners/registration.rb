# frozen_string_literal: true

module Legion
  module Extensions
    module Uais
      module Runners
        module Registration
          def register_worker(worker_id:, name:, owner_msid:, extension_name:, **opts)
            return mock_register(worker_id, name) if mock_mode?

            payload = {
              worker_id:      worker_id,
              name:           name,
              owner_msid:     owner_msid,
              extension_name: extension_name,
              risk_tier:      opts[:risk_tier],
              team:           opts[:team],
              business_role:  opts[:business_role]
            }.compact

            response = uais_post('/api/v1/agents', payload)
            { registered: response[:success], uais_id: response[:data]&.dig(:id), worker_id: worker_id }
          rescue StandardError => e
            soft_warn("UAIS registration failed for #{worker_id}: #{e.message}")
            { registered: false, worker_id: worker_id, error: e.message }
          end

          def deregister_worker(worker_id:, reason: nil)
            return mock_deregister(worker_id) if mock_mode?

            response = uais_post("/api/v1/agents/#{worker_id}/deregister", { reason: reason })
            { deregistered: response[:success], worker_id: worker_id }
          rescue StandardError => e
            soft_warn("UAIS deregistration failed for #{worker_id}: #{e.message}")
            { deregistered: false, worker_id: worker_id, error: e.message }
          end

          def check_registration(worker_id:)
            return { registered: true, mock: true } if mock_mode?

            response = uais_get("/api/v1/agents/#{worker_id}")
            { registered: response[:success], data: response[:data] }
          rescue StandardError => e
            soft_warn("UAIS registration check failed for #{worker_id}: #{e.message}")
            { registered: false, error: e.message }
          end

          def airb_status(worker_id:)
            return { status: 'approved', mock: true } if mock_mode?

            response = uais_get("/api/v1/agents/#{worker_id}/airb")
            { status: response.dig(:data, :status), data: response[:data] }
          rescue StandardError => e
            soft_warn("UAIS AIRB check failed for #{worker_id}: #{e.message}")
            { status: 'unknown', error: e.message }
          end

          private

          def uais_settings
            settings[:options] || {}
          end

          def uais_post(path, body)
            conn = connection(**uais_connection_opts)
            req = build_request(:post, path, body: body, api_key: uais_settings[:api_key])
            resp = conn.request(req)
            parse_response(resp)
          end

          def uais_get(path)
            conn = connection(**uais_connection_opts)
            req = build_request(:get, path, api_key: uais_settings[:api_key])
            resp = conn.request(req)
            parse_response(resp)
          end

          def uais_connection_opts
            {
              base_url: uais_settings[:base_url] || 'https://api.uais.uhg.com',
              api_key:  uais_settings[:api_key],
              timeout:  uais_settings[:timeout] || 30
            }
          end

          def parse_response(resp)
            body = begin
              Legion::JSON.load(resp.body) # rubocop:disable Legion/HelperMigration/DirectJson
            rescue StandardError => _e
              {}
            end
            { success: resp.is_a?(Net::HTTPSuccess), status: resp.code.to_i, data: body }
          end

          def mock_mode?
            uais_settings[:mock] == true || uais_settings[:base_url].nil?
          end

          def mock_register(worker_id, name)
            soft_warn("UAIS mock mode: register #{name} (#{worker_id})")
            { registered: true, mock: true, worker_id: worker_id }
          end

          def mock_deregister(worker_id)
            soft_warn("UAIS mock mode: deregister #{worker_id}")
            { deregistered: true, mock: true, worker_id: worker_id }
          end

          def soft_warn(message)
            Legion::Logging.warn("[lex-uais] #{message}") if defined?(Legion::Logging) # rubocop:disable Legion/HelperMigration/DirectLogging, Legion/HelperMigration/LoggingGuard
          end

          include Helpers::Client if defined?(Helpers::Client)
        end
      end
    end
  end
end
