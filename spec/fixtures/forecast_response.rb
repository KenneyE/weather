module Fixtures
  module ForcastResponse
    def self.data
      {
        "latitude": 52.54149,
        "longitude": 13.359375,
        "generationtime_ms": 0.0319480895996094,
        "utc_offset_seconds": 0,
        "timezone": "GMT",
        "timezone_abbreviation": "GMT",
        "elevation": 38,
        "current_units": {
          "time": "iso8601",
          "interval": "seconds",
          "temperature_2m": "°F"
        },
        "current": {
          "time": "2024-05-15T18:00",
          "interval": 900,
          "temperature_2m": 69.4
        },
        "daily_units": {
          "time": "iso8601",
          "temperature_2m_max": "°F",
          "temperature_2m_min": "°F"
        },
        "daily": {
          "time": [
            "2024-05-15",
            "2024-05-16",
            "2024-05-17"
          ],
          "temperature_2m_max": [76.5, 75.6, 73.2],
          "temperature_2m_min": [57.4, 54.3, 55.2]
        }
      }
    end

    def self.error_response
      { "error" => true,
        "reason" =>
         "Data corrupted at path ''. Cannot initialize SurfaceAndPressureVariable from invalid String value invalid." }
    end
  end
end
