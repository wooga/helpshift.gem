require File.dirname(File.expand_path(__FILE__)) + '/../test_helper.rb'

class AppTest < Minitest::Test
  def setup
    Helpshift.configure do |config|
      config.api_key = "foobaz"
      config.customer_domain = "foobar"
      config.base_domain = "helpshift.com"
    end
    FakeWeb.allow_net_connect = false
  end

  context "app" do
    should 'fetch list of all apps' do
      fake_response = [{"platform_ids" => ["blabla_platform_1337-123","blabla_platform_123-456"],
                       "publish_id" => 13,
                       "title" => "Blabla Game 1"},
                       {"platform_ids" => ["blabla_platform_007-008","blabla_platform_000-111"],
                       "publish_id" => 42,
                       "title" => "Blabla Game 2"}]

      FakeWeb.register_uri(:get, "https://#{Helpshift.configuration.api_key}@api.#{Helpshift.configuration.base_domain}/v1/#{Helpshift.configuration.customer_domain}/apps/",
                           :body => fake_response.to_json )

      apps_array = Helpshift::App.all

      assert_equal 2, apps_array.size

      fake_response.zip(apps_array).each do |expected_item,actual_item|
        assert actual_item.instance_of? Helpshift::App
        expected_item.each do |k, v|
          assert_equal v, actual_item.send(k)
        end
      end
    end

    should 'fetch one specific app by id' do
      app_publish_id = 1337
      fake_response_object = { :platform_ids => ["bla_platform_987654321-123456789"],
                               :updated_at => 1000000000000,
                               :created_at => 2000000000000,
                               :title => "Game Name",
                               :id => "moew_app_123456789-987654321",
                               :publish_id => app_publish_id }

      FakeWeb.register_uri(:get, "https://#{Helpshift.configuration.api_key}@api.#{Helpshift.configuration.base_domain}/v1/#{Helpshift.configuration.customer_domain}/apps/#{app_publish_id}",
                           :body => fake_response_object.to_json )

      found_app = Helpshift::App.find(app_publish_id)

      fake_response_object.each do |k, v|
        assert_equal v, found_app.send(k)
      end
      assert found_app.instance_of? Helpshift::App
    end
  end
end
