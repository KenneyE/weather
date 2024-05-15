class ForecastRetrievalService
  BASE_URL = 'https://api.open-meteo.com/v1/gfs'.freeze

  def self.coord_forecast(address)
    return if address.to_h.all?(:empty?)

    coordinates = GeocodingService.coordinates_from_address(address)

    params = {
      latitude: coordinates[:latitude],
      longitude: coordinates[:longitude],
      current: "temperature_2m",
      daily: ["temperature_2m_max", "temperature_2m_min"],
      temperature_unit: "fahrenheit",
      wind_speed_unit: "mph",
      precipitation_unit: "inch",
      forecast_days: 3
    };

    response = Faraday.get(BASE_URL, params)

    body = JSON.parse(response.body)
  end
end
