require 'rails_helper'

RSpec.describe 'Requests', type: :feature do
  let(:cats_unlimited_response) do
    [
      CatsPresenter.new(type: 'Big one', price: '500',
                        location: 'Lviv', image: 'http://googl/foto.jpg').instance_values
    ]
  end

  describe 'Opening results page' do
    context 'when there are results' do
      it 'shows best price' do
        visit result_request_path(cats_list: cats_unlimited_response)

        expect(page).to have_css(:p, text: 'Best price for your location - 500')
      end

      it 'shows cats' do
        visit result_request_path(cats_list: cats_unlimited_response)

        expect(page.all('tr td').first).to have_content('Big one')
      end
    end

    context 'when there are no results' do
      it 'renders message' do
        visit result_request_path

        expect(page).to have_content 'Sorry, no cats for your location'
      end
    end
  end
end
