module OandaServiceApi
  module Indicators
    attr_reader :indicator_path

    # GET /indicators
    def indicators
      Client.send(http_verb, "#{base_uri}/indicators", headers: headers)
    end

    # GET /indicators/:indicator
    # GET /indicators/point_and_figure
    def indicator(*args)
      id      = args.shift
      options = args.shift unless args.nil? || args.empty?
      options = {} unless options
      options.merge!(backtest_time: backtest_time) if backtest_time

      Client.send(http_verb, "#{base_uri}/indicators/#{indicator_path}", headers: headers, query: options)
    end
  end
end
