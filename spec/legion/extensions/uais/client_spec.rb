# frozen_string_literal: true

require 'legion/extensions/uais/client'

RSpec.describe Legion::Extensions::Uais::Client do
  describe '#initialize' do
    it 'defaults to mock mode when no base_url' do
      client = described_class.new
      expect(client.opts[:mock]).to be true
    end

    it 'defaults to mock mode when base_url is nil' do
      client = described_class.new(base_url: nil)
      expect(client.opts[:mock]).to be true
    end

    it 'disables mock when base_url is provided and mock not specified' do
      client = described_class.new(base_url: 'https://example.com')
      expect(client.opts[:mock]).to be false
    end

    it 'respects explicit mock: true even with base_url' do
      client = described_class.new(base_url: 'https://example.com', mock: true)
      expect(client.opts[:mock]).to be true
    end

    it 'stores api_key' do
      client = described_class.new(api_key: 'test-key')
      expect(client.opts[:api_key]).to eq('test-key')
    end

    it 'stores timeout' do
      client = described_class.new(timeout: 60)
      expect(client.opts[:timeout]).to eq(60)
    end
  end

  describe '#settings' do
    it 'wraps opts in :options key' do
      client = described_class.new
      expect(client.settings).to have_key(:options)
      expect(client.settings[:options]).to eq(client.opts)
    end
  end
end
