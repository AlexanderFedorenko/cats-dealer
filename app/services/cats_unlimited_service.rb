class CatsUnlimitedService
  API_URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json'.freeze

  class << self
    def all
      api_request_all
    end

    private

    def api_request_all
      response = RestClient.get(API_URL)
      JSON.parse(response.body).map(&:symbolize_keys)
    rescue RestClient::ExceptionWithResponse => e
      raise StandardError, e.response
    end
  end
end
