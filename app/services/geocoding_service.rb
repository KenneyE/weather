class GeocodingService
  BASE_URL = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze

  def self.coordinates_from_address(address)
    response = Faraday.get(BASE_URL,
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

  private

  def self.format_address(address)
    [address[:street], address[:city], address[:state], address[:zip]].map do |address_component|
      address_component.gsub(' ', '+')
    end.join(' ')
  end
end
