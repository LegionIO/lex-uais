# frozen_string_literal: true

RSpec.describe Legion::Extensions::Uais do
  it 'has a version number' do
    expect(Legion::Extensions::Uais::VERSION).not_to be_nil
  end

  it 'version is a string' do
    expect(Legion::Extensions::Uais::VERSION).to be_a(String)
  end

  describe '.default_settings' do
    subject(:settings) { described_class.default_settings }

    it 'returns a hash with options' do
      expect(settings).to be_a(Hash)
      expect(settings).to have_key(:options)
    end

    it 'defaults mock to true' do
      expect(settings[:options][:mock]).to be true
    end

    it 'defaults base_url to nil' do
      expect(settings[:options][:base_url]).to be_nil
    end

    it 'defaults timeout to 30' do
      expect(settings[:options][:timeout]).to eq(30)
    end
  end
end
