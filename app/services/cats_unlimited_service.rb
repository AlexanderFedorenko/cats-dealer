class CatsUnlimitedService
  API_URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json'.freeze

  class << self
    def all
      api_request
    end

    def filtered(params)
      result = api_request

      result.select do |cat|
        cat[:type] == params[:type] && cat[:location] == params[:location]
      end
    end

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
        .map { |cat| cat.transform_keys { |key| key == :name ? :type : key } }
    end
  end
end
