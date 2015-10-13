require File.dirname(File.expand_path(__FILE__)) + '/../test_helper.rb'

class Issue < Minitest::Test
  context "issue" do
    def setup
      config = Helpshift.configuration
      config.customer_domain ="foobar"
      config.api_key = "foobaz"
    end

    should "create new issue" do
      FakeWeb.register_uri(:post, %r|https://api.#{Helpshift.configuration.base_domain}/|,
                           :body => "empty")

      issue = Helpshift::Issue.new
      issue.email = "testuser@test.com"
      issue.title = "test issue title"
      issue.message_body = "test issue message body"
      issue.app_id="test_app_123456-987654"
      issue.platform_type = "android"
      issue.tags = ["test_tag1", "test_tag2"]
      issue.meta = { "meta-data" => "bla" }

      issue.create

      last_request = FakeWeb.last_request

      assert_equal "email=testuser%40test.com&title=test%20issue%20title&" +
                   "message-body=test%20issue%20message%20body&app-id=test_app_123456-987654&"+
                   "platform-type=android&tags=%5B%22test_tag1%22%2C%22test_tag2%22%5D&"+
                   "meta=%7B%22meta-data%22%3A%22bla%22%7D", last_request.body
      assert_equal "POST", last_request.method
      assert_equal "/v1/test/issues", last_request.path
    end
  end
end
