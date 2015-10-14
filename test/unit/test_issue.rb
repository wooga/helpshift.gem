require File.dirname(File.expand_path(__FILE__)) + '/../test_helper.rb'
require 'cgi'
require 'json'

class Issue < Minitest::Test
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
      FakeWeb.register_uri(:post, %r|https://#{Helpshift.configuration.api_key}@api.#{Helpshift.configuration.base_domain}/|,
                             :body => "empty")

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
      request_body = Hash[CGI::parse(last_request.body).map {|k,v| [k,v.first]}]

      request_body.each do |key, value|
        cgi_param_to_attr = { "message-body" => "message_body",
                              "app-id" => "app_id",
                              "platform-type" => "platform_type"}
        issue_value = issue.send(cgi_param_to_attr[key] || key)
        request_value = value
        if(issue_value.kind_of?(Array))
          request_value = JSON.parse(request_value)
          assert (issue_value - request_value).empty?, "Failed for #{key}"
        elsif(issue_value.kind_of?(Hash))
          request_value = JSON.parse(request_value)
          request_value.each do |field_key, field_value|
            assert_equal field_value, issue_value[field_key], "Failed for #{key}"
          end
        else
          assert_equal request_value, issue_value, "Failed for #{key}"
        end
      end

      assert_equal "POST", last_request.method
      assert_equal "/v1/#{Helpshift.configuration.customer_domain}/issues", last_request.path
    end
  end
end
