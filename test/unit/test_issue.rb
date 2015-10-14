require File.dirname(File.expand_path(__FILE__)) + '/../test_helper.rb'
require 'cgi'
require 'json'

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
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:post, %r|https://#{Helpshift.configuration.api_key}@api.#{Helpshift.configuration.base_domain}/|,
                             :body => "empty")

      issue               = Helpshift::Issue.new
      issue.email         = "testuser@test.com"
      issue.title         = "test issue title"
      issue.message_body  = "test issue message body"
      issue.app_id        = "test_app_123456-987654"
      issue.platform_type = "android"
      issue.tags          = ["test_tag1", "test_tag2"]
      issue.meta          = { "meta-data" => "bla" }

      issue.create

      last_request = FakeWeb.last_request

      request_body = CGI::parse(last_request.body)

      request_body.each do |key, value|
        unless key == "message-body"
          issue_value = issue.send(key.gsub '-', '_')
          request_value = value[0]
          if(issue_value.kind_of? Array)
            request_value = JSON.parse(request_value)
            assert (issue_value - request_value).empty?, "Failed for #{key}"
          elsif (issue_value.kind_of? Hash)
            request_value = JSON.parse(request_value)
            request_value.each do |field_key, field_value|
              assert_equal field_value, issue_value[field_key], "Failed for #{key}"
            end
          else
            assert_equal request_value, issue_value, "Failed for #{key}"
          end
        end
      end

      assert_equal "POST", last_request.method
      assert_equal "/v1/#{Helpshift.configuration.customer_domain}/issues", last_request.path
    end
  end
end
