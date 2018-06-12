require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  let(:api_response) {
    '[{"name": "Abyssin","price": "500","location": "Lviv","image": "https://akamaized.net/foto.jpg"}]'
  }

  describe 'GET #new' do
    before do
      get 'new'
    end

    it 'renders template' do
      expect(response).to render_template(:new)
    end

    it 'responds with correct status' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    subject do
      post 'create', params: request_params
    end

    let(:request_params) { {cats_type: 'Abyssin', user_location: 'Lviv'} }

    let!(:stubbed_api_request) {
      stub_request(:get, "https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json")
          .to_return(status: 200, body: api_response)
    }

    it 'makes API call to get data' do
      subject

      expect(stubbed_api_request).to have_been_requested
    end

    it 'redirects to request results page' do
      expect(subject)
          .to redirect_to(
                  result_request_path(cats_list: JSON.parse(api_response), cat_type: 'Abyssin', location: 'Lviv')
              )
    end
  end

  describe 'GET #result' do
    before do
      get 'result', params: {cats_list: JSON.parse(api_response), cat_type: 'Abyssin', location: 'Lviv'}
    end

    it 'renders template' do
      expect(response).to render_template(:result)
    end

    it 'responds with correct status' do
      expect(response).to have_http_status(:ok)
    end

    it 'sets correct results' do
      expect(assigns(:cats_list).first[:name]).to eq JSON.parse(api_response).first['name']
      expect(assigns(:cats_list).first[:price]).to eq JSON.parse(api_response).first['price']
      expect(assigns(:cats_list).first[:location]).to eq JSON.parse(api_response).first['location']
      expect(assigns(:cats_list).first[:image]).to eq JSON.parse(api_response).first['image']
    end
  end
end
