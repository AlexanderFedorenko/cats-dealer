class CatsUnlimitedService < ShopService
  API_URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json'.freeze

  class << self
    private

    def api_request
      response = RestClient.get(API_URL)
      transform_response(response)
    rescue RestClient::ExceptionWithResponse => e
      raise StandardError, e.response
    end

    def transform_response(response)
      JSON
        .parse(response.body)
        .map(&:symbolize_keys)
        .map do |cat|
          CatsPresenter.new(cat.transform_keys { |key| key == :name ? :type : key })
        end
    end
  end
end
