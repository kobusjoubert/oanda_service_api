module OandaServiceApi
  class << self
    def new(options = {})
      Client.new(options)
    end
  end
end
