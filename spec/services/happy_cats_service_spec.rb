require 'rails_helper'

RSpec.describe HappyCatsService do
  let(:parsed_api_response) do
    [
      CatsPresenter.new(
        type: 'American Curl', price: '650',
        location: 'Odessa', image: 'https://olxua-ring07.akamaized.net/images_slandocomua/113528769_3_1000x700_amerikanskie-kerly-koshki-s-chelovecheskim-litsom-koshka-kompanon-koti_rev022.jpg'
      )
    ]
  end

  describe '.filtered' do
    it 'calls .api_request method' do
      allow(described_class).to receive(:api_request)

      described_class.all

      expect(described_class).to have_received(:api_request)
    end

    it 'returns filtered with first cat', vcr: {cassette_name: 'happy_cats_with_many_cats'} do
      expect(described_class
               .filtered(type: 'American Curl', location: 'Odessa')
               .first['cat'][:type])
        .to eq 'American Curl'
    end

    it 'returns filtered with second cat', vcr: {cassette_name: 'happy_cats_with_many_cats'} do
      expect(described_class
               .filtered(type: 'American Curl', location: 'Odessa')
               .second['cat'][:type])
        .to eq 'Bengal'
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

    context 'when there is one cat', vcr: {cassette_name: 'happy_cats_with_one_cat'} do
      it { is_expected.to be_a(Array) }
      it { expect(call.first).to be_a(CatsPresenter) }

      it 'returns array with cats' do
        expect(call.first).to have_attributes(type: 'American Curl', price: '650')
      end
    end

    context 'when there are many cats', vcr: {cassette_name: 'happy_cats_with_many_cats'} do
      let(:parsed_api_response) do
        [
          {
            type: 'American Curl', price: '650',
            location: 'Odessa', image: 'https://olxua-ring07.akamaized.net/images_slandocomua/113528769_3_1000x700_amerikanskie-kerly-koshki-s-chelovecheskim-litsom-koshka-kompanon-koti_rev022.jpg'
          },
          {
            type: 'Bengal', price: '800',
            location: 'Odessa', image: 'https://olxua-ring01.akamaized.net/images_slandocomua/351717184_8_1000x700_bengalskie-kotyata-_rev029.jpg'
          }
        ]
      end

      it { is_expected.to be_a(Array) }
      it { expect(call.first).to be_a(CatsPresenter) }

      it 'returns array with first cat' do
        expect(call.first).to have_attributes(type: 'American Curl', price: '650')
      end

      it 'returns array with second cat' do
        expect(call.second).to have_attributes(type: 'Bengal', price: '800')
      end
    end

    context 'when there are no cats', vcr: {cassette_name: 'happy_cats_with_no_cats'} do
      it 'return an empty array' do
        expect(described_class.all).to eq([])
      end
    end
  end
end
