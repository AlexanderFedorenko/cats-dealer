require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  let(:cats_unlimited_response) do
    [
      {
        type: 'Big one', price: '500',
        location: 'Lviv', image: 'http://googl/foto.jpg'
      }
    ]
  end

  let(:happy_cats_response) do
    [
      {
        type: 'Big one', price: '100500',
        location: 'Lviv', image: 'http://googl/foto.jpg'
      }
    ]
  end

  let(:results_route_params) do
    {cats_list: cats_unlimited_response.concat(happy_cats_response)}
  end

  describe 'GET #new' do
    subject(:controller_request) do
      get 'new'
    end

    it 'renders template' do
      expect(controller_request).to render_template(:new)
    end

    it 'responds with correct status' do
      expect(controller_request).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    subject(:controller_request) do
      post 'create', params: request_params
    end

    let(:request_params) { {cats_type: 'Big one', user_location: 'Lviv'} }

    before do
      allow(CatsUnlimitedService).to receive(:filtered).and_return(cats_unlimited_response)
      allow(HappyCatsService).to receive(:filtered).and_return(happy_cats_response)
    end

    it 'makes call to the CatsUnlimitedService filtered method' do
      controller_request

      expect(CatsUnlimitedService)
        .to have_received(:filtered).with(type: 'Big one', location: 'Lviv')
    end

    it 'makes call to the HappyCatsService filtered method' do
      controller_request

      expect(HappyCatsService)
        .to have_received(:filtered).with(type: 'Big one', location: 'Lviv')
    end

    it 'redirects to request results page' do
      expect(controller_request)
        .to redirect_to(
              result_request_path(results_route_params)
            )
    end
  end

  describe 'GET #result' do
    subject(:controller_request) do
      get 'result', params: results_route_params
    end

    it 'renders template' do
      expect(controller_request).to render_template(:result)
    end

    it 'responds with correct status' do
      expect(controller_request).to have_http_status(:ok)
    end

    it 'sets combined result of first service' do
      controller_request

      expect(assigns(:cats_list).first[:type]).to eq cats_unlimited_response.first[:type]
    end

    it 'sets combined result of second service' do
      controller_request

      expect(assigns(:cats_list).second[:type]).to eq happy_cats_response.first[:type]
    end

    it 'handles empty result' do
      get 'result', params: {cat_type: 'Big one', location: 'Lviv'}

      expect(assigns(:cats_list)).to eq nil
    end
  end
end
