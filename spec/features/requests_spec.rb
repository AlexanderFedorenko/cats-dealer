require 'rails_helper'

RSpec.feature 'Requests', type: :feature do
  let(:api_response) {
    '[{"name": "Abyssin","price": "500","location": "Lviv","image": "https://akamaized.net/foto.jpg"}]'
  }

  describe 'Opening results page' do
    context 'when there are results' do
      it 'renders results' do
        visit result_request_path(cats_list: JSON.parse(api_response), cat_type: 'Abyssin', location: 'Lviv')

        expect(page).to have_css(:p, text: 'Best price for your location - 500')

        expect(page.all('tr td')[0]).to have_content('Abyssin')
      end
    end

    context 'when there are no results' do
      it 'renders message' do
        visit result_request_path(cats_list: JSON.parse(api_response), cat_type: 'Absent cat', location: 'Unknown city')

        expect(page).to have_content 'Sorry, no cats for your location'
      end
    end
  end
end
