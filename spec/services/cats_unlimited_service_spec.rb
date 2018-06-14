require 'rails_helper'

RSpec.describe CatsUnlimitedService do
  let!(:stubbed_api_request) do
    stub_request(:get, 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json')
      .to_return(status: 200, body: api_response)
  end

  let(:api_response) do
    '[{"name": "Abyssin","price": "500","location": "Lviv",'\
      '"image": "https://akamaized.net/foto.jpg"}]'
  end

  let(:parsed_api_response) do
    [{name: 'Abyssin', price: '500',
      location: 'Lviv', image: 'https://akamaized.net/foto.jpg'}]
  end

  describe '.all' do
    it 'calls .api_request_all method' do
      allow(described_class).to receive(:api_request_all)

      described_class.all

      expect(described_class).to have_received(:api_request_all)
    end

    it 'returns array with cats' do
      expect(described_class.all).to eq(parsed_api_response)
    end
  end

  describe '.api_request_all' do
    it 'makes an API call' do
      described_class.all

      expect(stubbed_api_request).to have_been_requested
    end

    it 'returns array with cats' do
      expect(described_class.all).to eq(parsed_api_response)
    end

    it 'throws an exception in case of error' do
      stub_request(:get, 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json')
        .to_return(status: 503)

      expect { described_class.all }.to raise_error(StandardError)
    end
  end
end
