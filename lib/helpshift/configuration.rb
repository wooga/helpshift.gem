require 'rest-client'

module Helpshift
  class Configuration
    attr_accessor :api_key, :base_domain, :customer_domain

    def initialize
      @base_domain     = 'helpshift.com'
      @customer_domain = 'test'
    end
  end
end
