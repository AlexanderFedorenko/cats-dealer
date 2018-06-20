require 'rails_helper'

RSpec.describe CatsUnlimitedService do
  let(:api_response_parsed) do
    [
      {
        type: 'Abyssin', price: 500,
        location: 'Lviv', image: 'https://olxua-ring02.akamaized.net/images_slandocomua/476948786_2_1000x700_abissenysh-chempion-fotografii.jpg'
      },
      {
        type: 'Abyssin', price: '550',
        location: 'Lviv', image: 'https://olxua-ring10.akamaized.net/images_slandocomua/342850976_3_1000x700_abidetki-koti_rev006.jpg'
      }
    ]
  end

  describe '.all', vcr: {cassette_name: 'cats_unlimited_with_many_cats'} do
    it 'calls .api_request method' do
      allow(described_class).to receive(:api_request)

      described_class.all

      expect(described_class).to have_received(:api_request)
    end

    it 'returns array with cats' do
      expect(described_class.all.first).to have_attributes(type: 'Abyssin', price: 500)
    end
  end

  describe '.filtered', vcr: {cassette_name: 'cats_unlimited_with_many_cats'} do
    subject(:call) { described_class.filtered }

    let(:api_response_parsed) do
      [
        {
          type: 'Abyssin', price: 500,
          location: 'Lviv', image: 'https://olxua-ring02.akamaized.net/images_slandocomua/476948786_2_1000x700_abissenysh-chempion-fotografii.jpg'
        },
        {
          type: 'Abyssin', price: '550',
          location: 'Lviv', image: 'https://olxua-ring10.akamaized.net/images_slandocomua/342850976_3_1000x700_abidetki-koti_rev006.jpg'
        }
      ]
    end

    it 'calls .api_request method' do
      allow(described_class).to receive(:api_request)

      described_class.all

      expect(described_class).to have_received(:api_request)
    end

    it 'returns filtered array with first cat' do
      expect(described_class
               .filtered(type: 'American Curl', location: 'Odessa')
               .first['cat'][:type])
        .to eq 'Abyssin'
    end

    it 'returns filtered array with second cat' do
      expect(described_class
               .filtered(type: 'American Curl', location: 'Odessa')
               .second['cat'][:type])
        .to eq 'Abyssin'
    end
  end
end
