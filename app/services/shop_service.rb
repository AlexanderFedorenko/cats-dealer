class ShopService
  class << self
    def all
      api_request
    end

    def filtered(params)
      result = api_request

      result.select do |cat|
        cat.type == params[:type] && cat.location == params[:location]
      end

      result.map(&:instance_values)
    end
  end
end
