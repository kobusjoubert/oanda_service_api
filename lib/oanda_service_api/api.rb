module OandaServiceApi
  class Api
    include Indicators
    # include Instruments
    # include TradingViewUDF

    attr_accessor :client, :base_uri, :headers, :backtest_time, :last_action, :last_arguments
    attr_writer   :indicator_path #, :instrument

    def initialize(options = {})
      options.each do |key, value|
        self.send("#{key}=", value) if self.respond_to?("#{key}=")
      end

      raise OandaServiceApi::ApiError, 'No client object was supplid.' unless client
      @base_uri ||= client.base_uri
      @headers  ||= client.headers
    end

    class << self
      def api_methods
        Indicators.instance_methods # + Instruments.instance_methods + TradingViewUDF.instance_methods
      end
    end

    self.api_methods.each do |method_name|
      original_method = instance_method(method_name)

      define_method(method_name) do |*args, &block|
        # Add the block below before each of the api_methods to set the last_action and last_arguments.
        # Return the OandaApiV20::Api object to allow for method chaining when any of the api_methods have been called.
        # Only make an HTTP request to Oanda API When an action method like show, update, cancel, close or create was called.
        set_last_action_and_arguments(method_name, *args)
        return self unless http_verb

        original_method.bind(self).call(*args, &block)
      end
    end

    def method_missing(name, *args, &block)
      case name
      when :show, :create, :update, :cancel, :close
        set_http_verb(name, last_action)

        if respond_to?(last_action)
          api_result = {}
          client.update_last_api_request_at
          client.govern_api_request_rate

          begin
            response = Http::Exceptions.wrap_and_check do
              last_arguments.nil? || last_arguments.empty? ? send(last_action, &block) : send(last_action, *last_arguments, &block)
            end
          rescue Http::Exceptions::HttpException => e
            raise OandaServiceApi::RequestError, e.message
          end

          if response.body && !response.body.empty?
            api_result.merge!(JSON.parse(response.body))
          end
        end

        self.http_verb = nil
        api_result
      else
        super
      end
    end

    private

    attr_accessor :http_verb

    def set_last_action_and_arguments(action, *args)
      self.last_action    = action.to_sym
      self.last_arguments = args
    end

    def set_http_verb(action, last_action)
      self.http_verb =
        case action
        when :show
          :get
        when :update
          :patch
        when :create
          :post
        when :delete
          :delete
        else
          nil
        end
    end
  end
end
