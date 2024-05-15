require 'rails_helper'

describe GeocodingService do
  subject { described_class.new }

  let(:faraday_adapter) { Faraday::Adapter::Test::Stubs.new }
  let(:address) do
    {
      street: '123 My Street',
      city: 'Brooklyn',
      state: 'NY',
      zip: '12345',
    }
  end

  describe '#coordinates_from_address' do
    before do
      subject.connection.builder.adapter :test, faraday_adapter

      faraday_adapter.get('/maps/api/geocode/json') do
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
      let(:response_body) { Fixtures::GeocodingResponse.data }

      it 'returns coordinates' do
        expect(subject.coordinates_from_address(address)[:latitude]).not_to be_nil
        expect(subject.coordinates_from_address(address)[:longitude]).not_to be_nil
      end
    end
  end
end
