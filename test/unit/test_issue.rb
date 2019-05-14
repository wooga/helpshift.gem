require_relative '../test_helper.rb'
require 'cgi'
require 'json'

class Issue < Minitest::Test
  context "issue" do
    should "create new issue" do
      stub_request(:post,
                   "https://api.#{Helpshift.configuration.base_domain}/v1"+
                   "/#{Helpshift.configuration.customer_domain}/issues").to_return(
                     :body => "")

      issue = Helpshift::Issue.new.tap do |iss|
        iss.email         = "testuser@test.com"
        iss.title         = "test issue title"
        iss.message_body  = "test issue message body"
        iss.app_id        = "test_app_123456-987654"
        iss.platform_type = "android"
        iss.tags          = ["test_tag1", "test_tag2"]
        iss.meta          = {"meta-data" => "bla", "meta-data-two" => "foo"}
      end

      issue.create

      assert_requested(
        :post,
        "https://api.#{Helpshift.configuration.base_domain}/v1/#{Helpshift.configuration.customer_domain}/issues",
        times: 1) do |req|

          # Parse request_body to Hash and unwrap the contained values
          request_data = Hash[CGI.parse(req.body).map {|k,v| [k,v.first]}]

          request_data.each do |key, request_value|
            issue_attr_value = issue.send(CGI_PARAM_TO_ATTR_NAME[key] || key)

             case issue_attr_value
             when Array
               assert((issue_attr_value - JSON.parse(request_value)).empty?,
                      "Failed for #{key}")
             when Hash
               request_value = JSON.parse(request_value)
               request_value.each do |field_key, field_value|
                 assert_equal(field_value, issue_attr_value[field_key],
                              "Failed for #{key}")
               end
             else
               assert_equal request_value, issue_attr_value, "Failed for #{key}"
             end
           end
      end
    end
  end
end
