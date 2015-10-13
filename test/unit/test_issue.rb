require File.dirname(File.expand_path(__FILE__)) + '/../test_helper.rb'

class Issue < Minitest::Test
  def setup
    Helpshift.configure do |config|
      config.api_key = "foobaz"
      config.customer_domain = "foobar"
      config.base_domain = 'helpshift.com'
    end
  end

  context "issue" do
    should "create new issue" do

    end
  end
end
