require 'rest-client'
require_relative 'configuration'
require_relative 'helpshift'
require_relative 'issue'
require_relative 'app'

module HelpshiftGem

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    config = configuration
    block_given? ? yield(config) : config
    config
  end
end
