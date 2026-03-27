# frozen_string_literal: true

require 'legion/extensions/uais/helpers/client'

RSpec.describe Legion::Extensions::Uais::Helpers::Client do
  let(:test_class) { Class.new { include Legion::Extensions::Uais::Helpers::Client } }
  let(:instance) { test_class.new }

  describe '#connection' do
    it 'returns a Net::HTTP instance' do
      conn = instance.connection(base_url: 'https://example.com')
      expect(conn).to be_a(Net::HTTP)
    end

    it 'enables SSL for https' do
      conn = instance.connection(base_url: 'https://example.com')
      expect(conn.use_ssl?).to be true
    end

    it 'disables SSL for http' do
      conn = instance.connection(base_url: 'http://example.com')
      expect(conn.use_ssl?).to be false
    end

    it 'sets timeout' do
      conn = instance.connection(base_url: 'https://example.com', timeout: 15)
      expect(conn.open_timeout).to eq(15)
      expect(conn.read_timeout).to eq(15)
    end
  end

  describe '#build_request' do
    it 'creates a POST request' do
      req = instance.build_request(:post, '/api/v1/agents')
      expect(req).to be_a(Net::HTTP::Post)
    end

    it 'creates a GET request' do
      req = instance.build_request(:get, '/api/v1/agents/123')
      expect(req).to be_a(Net::HTTP::Get)
    end

    it 'sets content type to JSON' do
      req = instance.build_request(:post, '/test')
      expect(req['Content-Type']).to eq('application/json')
    end

    it 'sets authorization header when api_key provided' do
      req = instance.build_request(:get, '/test', api_key: 'my-key')
      expect(req['Authorization']).to eq('Bearer my-key')
    end

    it 'does not set authorization without api_key' do
      req = instance.build_request(:get, '/test')
      expect(req['Authorization']).to be_nil
    end

    it 'serializes body as JSON' do
      req = instance.build_request(:post, '/test', body: { name: 'TestBot' })
      expect(req.body).to include('TestBot')
    end
  end
end
