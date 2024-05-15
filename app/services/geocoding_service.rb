class GeocodingService
  BASE_URL = 'https://maps.googleapis.com'.freeze

  def coordinates_from_address(address)
    response = connection.get('/maps/api/geocode/json',
      {
        address: format_address(address),
        key: Rails.application.credentials.google.maps_api_key,
    })
    body = JSON.parse(response.body)

    if response.status == 200
      location = body["results"].first["geometry"]["location"]

      {
        latitude: location["lat"],
        longitude: location["lng"],
        errors: []
      }
    else
      {
        error: 'Sorry, we were not able to locate that address'
      }
    end
  end

  def connection
    @connection ||= Faraday.new(
      url: BASE_URL,
      headers: {'Content-Type' => 'application/json'}
    )
  end

  private

  def format_address(address)
    [address[:street], address[:city], address[:state], address[:zip]].map do |address_component|
      address_component.gsub(' ', '+')
    end.join(' ')
  end
end
