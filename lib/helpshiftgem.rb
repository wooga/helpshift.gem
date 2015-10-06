require 'rest-client'
require_relative 'configuration'
require_relative 'helpshift'
require_relative 'issue'

module HelpshiftGem

  def self.configuration
    @configuration ||= Configuration.new()
  end

  def self.configure
    config = configuration
  end
end
