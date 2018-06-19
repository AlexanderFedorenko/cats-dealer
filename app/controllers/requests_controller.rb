class RequestsController < ApplicationController
  def create
    result =
      CatsUnlimitedService.filtered(type: params[:cats_type], location: params[:user_location])

    redirect_to result_request_path(cats_list: result)
  end

  def result
    @cats_list = params[:cats_list]
  end
end
