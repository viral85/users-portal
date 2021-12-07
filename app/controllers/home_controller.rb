class HomeController < ApplicationController

  def import
    @result = User.import(file_params)
    render 'index'
  end

  private 

  def file_params
    params.require(:file)
  end
end
