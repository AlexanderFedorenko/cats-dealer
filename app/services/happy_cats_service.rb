class HappyCatsService < ShopService
  API_URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml'.freeze

  class << self
    private

    def api_request
      response = RestClient.get(API_URL)

      cats = Hash.from_xml(response.body)['cats']&.fetch('cat')

      transform_response(cats)
    end

    def transform_response(cats)
      cats = cats.is_a?(Array) ? cats : [cats]

      cats.compact.map do |cat|
        CatsPresenter.new(
          type: cat['title'],
          price: cat['cost'],
          location: cat['location'],
          image: cat['img']
        )
      end
    end
  end
end
