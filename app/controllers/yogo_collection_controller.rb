class YogoCollectionController < ApplicationController
  
  def show_data
    # this needs to actually find data (and be in a sensible place)
    @yogo_data = Yogo::Collection.get(params[:id]).yogo_data(params[:schema]).first
  end

end