class ForecastRetrievalService
  BASE_URL = 'https://api.open-meteo.com'.freeze

  def coord_forecast(address)
    # No address provided
    return if address.to_h.all?(:empty?)

    value_from_cache = cached_value(address)

    forecast_json = value_from_cache.presence || fetch_forecast(address)

    {
      data: JSON.parse(forecast_json),
      from_cache: value_from_cache.present?
    }
  end

  def connection
    @connection ||= Faraday.new(
      url: BASE_URL,
      headers: {'Content-Type' => 'application/json'}
    )
  end

  private

  def fetch_forecast(address)
    coordinates = GeocodingService.new.coordinates_from_address(address)

    response = connection.get('/v1/gfs', forecast_params(coordinates))

    write_cache_value(address, response.body)

    response.body
  end

  def forecast_params(coordinates)
    {
      latitude: coordinates[:latitude],
      longitude: coordinates[:longitude],
    current: "temperature_2m",
      daily: ["temperature_2m_max", "temperature_2m_min"],
      temperature_unit: "fahrenheit",
      wind_speed_unit: "mph",
      precipitation_unit: "inch",
      forecast_days: 7
    }
  end

  def cached_value(address)
    redis.get(address[:zip])
  end

  def write_cache_value(address, data)
    ttl_seconds = 30 * 60 # 30 Minutes
    redis.set(address[:zip], JSON.parse(data).merge(cached_at: Time.current).to_json, ex: ttl_seconds)
  end

  def redis
    Redis.new
  end
end
