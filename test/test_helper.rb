require 'rubygems'
require 'bundler'
require 'bundler/setup'

require 'minitest/autorun'
require 'minitest/unit'
require 'shoulda'
require 'shoulda/context'
require 'rr'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'helpshift'

class Minitest::Test
  CGI_PARAM_TO_ATTR_NAME =
    { "message-body"  => "message_body",
      "app-id"        => "app_id",
      "platform-type" => "platform_type"}

  def setup
    Helpshift.configure do |config|
      config.api_key         = "snafu"
      config.customer_domain = "foobar"
      config.base_domain     = 'helpshift.com'
    end
    FakeWeb.allow_net_connect = false
  end
end
