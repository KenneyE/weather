require 'rails_helper'

describe ForecastRetrievalService do
  subject { described_class.new }

  let(:faraday_adapter) { Faraday::Adapter::Test::Stubs.new }
  let(:geocoder) { instance_double(GeocodingService) }

  let(:coordinates) do
    {
      latitude: 52.54149,
      longitude: 13.359375,
    }
  end
  let(:address) do
    {
      street: '123 My Street',
      city: 'Brooklyn',
      state: 'NY',
      zip: '12345',
    }
  end

  describe '#coord_forecast' do
    before do
      allow(GeocodingService).to receive(:new).and_return(geocoder)
      allow(geocoder).to receive(:coordinates_from_address).and_return(coordinates)

      subject.connection.builder.adapter :test, faraday_adapter

      faraday_adapter.get('/v1/gfs') do
        [
          status_code,
          { 'Content-Type': 'application/json' },
          response_body.to_json
        ]
      end
    end

    after { Faraday.default_connection = nil }

    context 'with a successful response' do
      let(:status_code) { 200 }
      let(:response_body) { Fixtures::ForcastResponse.data }

      it 'returns current temperature' do
        expect(subject.coord_forecast(address)[:data]["current"]["temperature_2m"]).to eq(69.4)
      end

      it 'returns forecasted temperatures' do
        expect(subject.coord_forecast(address)[:data]["daily"]["temperature_2m_min"].first).to eq(57.4)
        expect(subject.coord_forecast(address)[:data]["daily"]["temperature_2m_max"].first).to eq(76.5)
      end
    end

    context 'with a failed request' do
      let(:status_code) { 400 }
      let(:response_body) { Fixtures::ForcastResponse.error_response }

      it 'returns an error' do
        expect(subject.coord_forecast(address)[:error]).to eq('Unable to get the forecast')
      end
    end
  end
end
