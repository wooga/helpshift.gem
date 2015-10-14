require_relative '../test_helper.rb'
require 'cgi'
require 'json'

class Issue < Minitest::Test
  CGI_PARAM_TO_ATTR_NAME = { "message-body" => "message_body",
                             "app-id" => "app_id",
                             "platform-type" => "platform_type"}

  def setup
    Helpshift.configure do |config|
      config.api_key         = "foobaz"
      config.customer_domain = "foobar"
      config.base_domain     = 'helpshift.com'
    end
    FakeWeb.allow_net_connect = false
  end

  context "issue" do
    should "create new issue" do
      FakeWeb.register_uri(:post, "https://#{Helpshift.configuration.api_key}@api.#{Helpshift.configuration.base_domain}/v1/#{Helpshift.configuration.customer_domain}/issues",
                           :body => "")

      issue               = Helpshift::Issue.new
      issue.email         = "testuser@test.com"
      issue.title         = "test issue title"
      issue.message_body  = "test issue message body"
      issue.app_id        = "test_app_123456-987654"
      issue.platform_type = "android"
      issue.tags          = ["test_tag1", "test_tag2"]
      issue.meta          = {"meta-data" => "bla"}

      issue.create

      last_request = FakeWeb.last_request

      # Parse request_body to Hash and unwrap the contained values
      request_data = Hash[CGI.parse(last_request.body).map {|k,v| [k,v.first]}]

      request_data.each do |key, value|
        issue_attr_value = issue.send(CGI_PARAM_TO_ATTR_NAME[key] || key)
        request_value = value
        if issue_attr_value.is_a?(Array)
          assert((issue_attr_value - JSON.parse(request_value)).empty?, "Failed for #{key}")
        elsif issue_attr_value.is_a?(Hash)
          request_value = JSON.parse(request_value)
          request_value.each do |field_key, field_value|
            assert_equal field_value, issue_attr_value[field_key], "Failed for #{key}"
          end
        else
          assert_equal request_value, issue_attr_value, "Failed for #{key}"
        end
      end

      assert_equal "POST", last_request.method
      assert_equal "/v1/#{Helpshift.configuration.customer_domain}/issues", last_request.path
    end
  end
end
