require 'rails_helper'

RSpec.describe CatsUnlimitedService do
  let!(:stubbed_api_request) do
    stub_request(:get, described_class::API_URL).to_return(status: 200, body: api_response)
  end

  let(:api_response) do
    '[{"name": "Big one","price": "500","location": "Lviv","image": "http://googl/foto.jpg"},'\
    '{"name": "Pinky","price": "100","location": "Lviv", "image": "http://googl/foto.jpg"},'\
    '{"name": "Big one","price": "300","location": "Odesa", "image": "http://googl/foto.jpg"}]'
  end

  let(:api_response_parsed) do
    [
      {
        type: 'Big one', price: '500',
        location: 'Lviv', image: 'http://googl/foto.jpg'
      },
      {
        type: 'Pinky', price: '100',
        location: 'Lviv', image: 'http://googl/foto.jpg'
      },
      {
        type: 'Big one', price: '300',
        location: 'Odesa', image: 'http://googl/foto.jpg'
      }
    ]
  end

  describe '.all' do
    it 'calls .api_request method' do
      allow(described_class).to receive(:api_request)

      described_class.all

      expect(described_class).to have_received(:api_request)
    end

    it 'returns array with cats' do
      expect(described_class.all).to eq(api_response_parsed)
    end
  end

  describe '.filtered' do
    let(:api_response_parsed) do
      [
        {
          type: 'Pinky', price: '100',
          location: 'Lviv', image: 'http://googl/foto.jpg'
        }
      ]
    end

    it 'calls .api_request method' do
      allow(described_class).to receive(:api_request)

      described_class.all

      expect(described_class).to have_received(:api_request)
    end

    it 'returns filtered array with cats' do
      expect(described_class.filtered(type: 'Pinky', location: 'Lviv'))
        .to eq(api_response_parsed)
    end
  end

  describe '.api_request' do
    it 'makes an API call' do
      described_class.all

      expect(stubbed_api_request).to have_been_requested
    end

    it 'returns array with cats' do
      expect(described_class.all).to eq(api_response_parsed)
    end

    it 'throws an exception in case of error' do
      stub_request(:get, described_class::API_URL).to_return(status: 503)

      expect { described_class.all }.to raise_error(StandardError)
    end
  end
end
