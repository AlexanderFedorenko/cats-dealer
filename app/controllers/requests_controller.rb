class RequestsController < ApplicationController
  def create
    result = CatsUnlimitedService.all

    redirect_to result_request_path(
                  cats_list: result,
                  cat_type: params[:cats_type],
                  location: params[:user_location]
                )
  end

  def result
    @cats_list = params[:cats_list].select do |list|
      list['location'] == params[:location] && list['type'] == params[:cat_type]
    end
  end
end
