require 'rails_helper'

RSpec.describe HappyCatsService do
  before do
    stub_request(:get, 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml')
      .to_return(status: 200, body: api_response)
  end

  let(:api_response) do
    '<?xml version="1.0" encoding="UTF-8"UTF-8?><cats>'\
    '<cat><title>American Curl</title><cost>650</cost><location>Odessa</location>'\
    '<img>https://akamaized.net/foto.jpg</img></cat></cats>'
  end

  let(:parsed_api_response) do
    [
      {
        type: 'American Curl', price: '650',
        location: 'Odessa', image: 'https://akamaized.net/foto.jpg'
      }
    ]
  end

  describe '.filtered' do
    let(:api_response) do
      '<?xml version="1.0" encoding="UTF-8"?><cats>'\
        '<cat><title>American Curl</title><cost>650</cost><location>Odessa</location>'\
        '<img>https://akamaized.net/foto.jpg</img></cat>'\
        '<cat><title>American Curl 2</title><cost>650</cost><location>Odessa</location>'\
        '<img>https://akamaized.net/foto.jpg</img></cat></cats>'
    end

    it 'calls .api_request method' do
      allow(described_class).to receive(:api_request)

      described_class.all

      expect(described_class).to have_received(:api_request)
    end

    it 'returns filtered array with cats' do
      expect(described_class.filtered(type: 'American Curl', location: 'Odessa'))
        .to eq(parsed_api_response)
    end
  end

  describe '.all' do
    subject(:call) { described_class.all }

    it 'calls .api_request method' do
      allow(described_class).to receive(:api_request)

      described_class.all

      expect(described_class).to have_received(:api_request)
    end

    it 'throws an exception in case of error' do
      stub_request(:get, 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml')
        .to_return(status: 503)

      expect { described_class.all }.to raise_error(StandardError)
    end

    context 'when there are one cat in the result' do
      it { is_expected.to be_a(Array) }
      it { expect(call.first).to be_a(Hash) }

      it 'returns array with cats' do
        expect(described_class.all).to eq(parsed_api_response)
      end
    end

    context 'when there are two cats in the result' do
      let(:api_response) do
        '<?xml version="1.0" encoding="UTF-8"?><cats>'\
        '<cat><title>American Curl 1</title><cost>650</cost><location>Odessa</location>'\
        '<img>https://akamaized.net/foto.jpg</img></cat>'\
        '<cat><title>American Curl 2</title><cost>650</cost><location>Odessa</location>'\
        '<img>https://akamaized.net/foto.jpg</img></cat></cats>'
      end

      let(:parsed_api_response) do
        [
          {
            type: 'American Curl 1', price: '650',
            location: 'Odessa', image: 'https://akamaized.net/foto.jpg'
          },
          {
            type: 'American Curl 2', price: '650',
            location: 'Odessa', image: 'https://akamaized.net/foto.jpg'
          }
        ]
      end

      it { is_expected.to be_a(Array) }
      it { expect(call.first).to be_a(Hash) }

      it 'returns array with cats' do
        expect(described_class.all).to eq(parsed_api_response)
      end
    end

    context 'when there are no cats in the result' do
      let(:api_response) do
        '<?xml version="1.0" encoding="UTF-8"UTF-8?><cats></cats>'
      end

      it 'return an empty array' do
        expect(described_class.all).to eq([])
      end
    end
  end
end
