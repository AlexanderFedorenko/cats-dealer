class RequestsController < ApplicationController
  def new
    @cat_types = [
      'Bengal', 'Abyssin', 'Persian', 'American Curl',
      'Devon Rex', 'Maine Coon', 'Sphynx'
    ]
    @user_locations = %w[Lviv Kiev Odessa]
  end

  def create
    result = []

    filter_params = {type: params[:cats_type], location: params[:user_location]}

    result.concat CatsUnlimitedService.filtered(filter_params)
    result.concat HappyCatsService.filtered(filter_params)

    redirect_to result_request_path(cats_list: result)
  end

  def result
    @cats_list = params[:cats_list]
  end
end
