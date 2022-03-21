# OandaServiceApi

Ruby client that supports the [Oanda Service API](https://github.com/kobusjoubert/oanda_service) methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oanda_service_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oanda_service_api

## Usage

Add the following to your ruby program:

    require 'oanda_service_api'

Initialise a client:

    client = OandaServiceApi.new(email: 'me@somewhere.com', authentication_token: 'my_authentication_token')

If you would like to use the staging service, default is production:

    client = OandaServiceApi.new(email: 'me@somewhere.com', authentication_token: 'my_authentication_token', environment: 'staging')

If you need your requests to go through a proxy:

    client = OandaServiceApi.new(email: 'me@somewhere.com', authentication_token: 'my_authentication_token', proxy_url: 'https://user:pass@proxy.com:80')

When backtesting, remember to pass along backtest_time in iso8601 format:

    client = OandaServiceApi.new(email: 'me@somewhere.com', authentication_token: 'my_authentication_token', backtest_time: '2017-12-12T12:00:00.000000000Z')

You can adjust the persistend connection pool size, the default is 256:

    client = OandaServiceApi.new(email: 'me@somewhere.com', authentication_token: 'my_authentication_token', connection_pool_size: 10)

You can adjust the number of requests per second allowed to OandaService API, the default is 100:

    client = OandaServiceApi.new(email: 'me@somewhere.com', authentication_token: 'my_authentication_token', max_requests_per_second: 10)

## Examples

### Indicators

```ruby
client.indicators.show
```

```ruby
client.indicator(:point_and_figure).show
```

One indicator setting.
```ruby
options = {
  instrument: 'EUR_USD',
  granularity: 'M5',
  box_size: '20',
  reversal_amount: '3',
  high_low_close: 'high_low',
  count: '100'
}

client.indicator('point_and_figure', options).show
```

Multiple indicator settings.
```ruby
options = {
  instrument: 'EUR_USD',
  granularity: 'H1,M5',
  box_size: '10,20',
  reversal_amount: '3,3',
  high_low_close: 'close,high_low',
  count: '1,100'
}

client.indicator('point_and_figure', options).show
```

## Responses

All API responses will be returned with the following JSON structure:

```json
{
  "data": [{
    "type": "indicators_point_and_figure",
    "id": "1",
    "attributes": {
      "instrument": "EUR_USD",
      "granularity": "m5",
      "box_size": 20,
      "reversal_amount": 3,
      "high_low_close": "high_low",
      "xo": "x",
      "xo_length": 4,
      "xo_box_price": 117800,
      "xo_price": 1.178,
      "trend": "up",
      "trend_length": 2,
      "trend_box_price": 117000,
      "trend_price": 1.17,
      "pattern": "double_top",
      "candle_at": "2017-11-27T22:00:00.00000000Z",
      "created_at": "2017-11-30T14:30:00.19215900Z",
      "updated_at": "2017-11-30T14:30:00.19215900Z"
    }
  }, {
    "type": "indicators_point_and_figure",
    "id": "2",
    "attributes": {
      "instrument": "EUR_USD",
      "granularity": "m5",
      "...": "..."
    }
  }, {
    "type": "indicators_point_and_figure",
    "id": "3",
    "attributes": {
      "instrument": "EUR_USD",
      "granularity": "h1",
      "...": "..."
    }
  }]
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [github.com](https://github.com).

## Exceptions

A `OandaServiceApi::RequestError` will be raised when a request to the Oanda Service API failed for any reason.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kobusjoubert/oanda_service_api.
