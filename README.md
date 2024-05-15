# README

This is a Ruby on Rails application for determining the weather at a given address. The address is then geocoded into lat/lon coordinates, which are then used to fetch the current and future weather for that location. The zip code provided in the form is used as a cache key to cache the forecast for 30 minutes. 

This application relies on a couple of external services:
- Google Maps API - For geocoding of the address
- Open-Meteo - Weather forecasting

## Getting Started

In order to run this application, you will need the following installed:
- Ruby v3.3.0
- Postgres v14
- Redis

You will also need to have Postgres and Redis running. 

You will also need a Google Maps API key added to your Rails credentials as follows:

```
google:
  maps_api_key: YOUR_API_KEY
```


## Running Tests

To run the automated tests, simply run `bundle exec rspec`