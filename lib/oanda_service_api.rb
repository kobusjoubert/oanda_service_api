require 'json'
require 'httparty'
require 'persistent_httparty'
require 'http/exceptions'

require 'oanda_service_api/version'
require 'oanda_service_api/exceptions'
require 'oanda_service_api/indicators'
require 'oanda_service_api/client'
require 'oanda_service_api/api'
require 'oanda_service_api/oanda_service_api'

Bundler.require(*[:default, ENV['APP_ENV'], ENV['RAILS_ENV']].compact)
