class ForecastsController < ApplicationController
  def show
    @forecast = ForecastRetrievalService.coord_forecast(address_params)
  end

  private

  def address_params
    params.permit(:street, :city, :state, :zip)
  end
end
