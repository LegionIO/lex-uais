# frozen_string_literal: true

require 'legion/extensions/uais/client'

RSpec.describe Legion::Extensions::Uais::Runners::Registration do
  let(:client) { Legion::Extensions::Uais::Client.new }
  let(:live_client) { Legion::Extensions::Uais::Client.new(base_url: 'https://api.uais.uhg.com', api_key: 'test-key', mock: false) }

  describe 'mock mode' do
    describe '#register_worker' do
      subject(:result) do
        client.register_worker(worker_id: 'w-123', name: 'TestBot', owner_msid: 'ms456', extension_name: 'lex-test')
      end

      it 'returns registered: true' do
        expect(result[:registered]).to be true
      end

      it 'includes mock: true' do
        expect(result[:mock]).to be true
      end

      it 'includes the worker_id' do
        expect(result[:worker_id]).to eq('w-123')
      end
    end

    describe '#deregister_worker' do
      subject(:result) { client.deregister_worker(worker_id: 'w-123') }

      it 'returns deregistered: true' do
        expect(result[:deregistered]).to be true
      end

      it 'includes mock: true' do
        expect(result[:mock]).to be true
      end
    end

    describe '#check_registration' do
      subject(:result) { client.check_registration(worker_id: 'w-123') }

      it 'returns registered: true' do
        expect(result[:registered]).to be true
      end

      it 'includes mock: true' do
        expect(result[:mock]).to be true
      end
    end

    describe '#airb_status' do
      subject(:result) { client.airb_status(worker_id: 'w-123') }

      it 'returns status approved' do
        expect(result[:status]).to eq('approved')
      end

      it 'includes mock: true' do
        expect(result[:mock]).to be true
      end
    end
  end

  describe 'mock_mode?' do
    it 'is true when base_url is nil' do
      c = Legion::Extensions::Uais::Client.new(base_url: nil)
      expect(c.send(:mock_mode?)).to be true
    end

    it 'is true when mock is explicitly true' do
      c = Legion::Extensions::Uais::Client.new(base_url: 'https://example.com', mock: true)
      expect(c.send(:mock_mode?)).to be true
    end

    it 'is false when base_url is set and mock is false' do
      c = Legion::Extensions::Uais::Client.new(base_url: 'https://example.com', mock: false)
      expect(c.send(:mock_mode?)).to be false
    end
  end

  describe 'soft-warn on failure' do
    it 'returns error hash instead of raising on register failure' do
      allow(live_client).to receive(:connection).and_raise(Errno::ECONNREFUSED)
      result = live_client.register_worker(worker_id: 'w-fail', name: 'FailBot', owner_msid: 'ms789', extension_name: 'lex-fail')
      expect(result[:registered]).to be false
      expect(result[:error]).to include('Connection refused')
    end

    it 'returns error hash instead of raising on deregister failure' do
      allow(live_client).to receive(:connection).and_raise(Errno::ECONNREFUSED)
      result = live_client.deregister_worker(worker_id: 'w-fail')
      expect(result[:deregistered]).to be false
      expect(result[:error]).to include('Connection refused')
    end

    it 'returns error hash instead of raising on check_registration failure' do
      allow(live_client).to receive(:connection).and_raise(Errno::ECONNREFUSED)
      result = live_client.check_registration(worker_id: 'w-fail')
      expect(result[:registered]).to be false
      expect(result[:error]).to include('Connection refused')
    end

    it 'returns error hash instead of raising on airb_status failure' do
      allow(live_client).to receive(:connection).and_raise(Errno::ECONNREFUSED)
      result = live_client.airb_status(worker_id: 'w-fail')
      expect(result[:status]).to eq('unknown')
      expect(result[:error]).to include('Connection refused')
    end
  end
end
