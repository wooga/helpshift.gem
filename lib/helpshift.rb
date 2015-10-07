require 'json'
require 'rest-client'
require 'base64'
require 'helpshift/app'
require 'helpshift/configuration'
require 'helpshift/issue'

module Helpshift
  extend self

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    config = configuration
    block_given? ? yield(config) : config
    config
  end
end
