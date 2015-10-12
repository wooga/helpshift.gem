require File.dirname(File.expand_path(__FILE__)) + '/../test_helper.rb'

class AppTest < Minitest::Test
  context "app" do

    def setup
      config = Helpshift.configuration
      config.customer_domain ="foobar"
      config.api_key = "foobaz"
    end

    should 'fetch list of all apps' do
      FakeWeb.register_uri(:get, "https://api.#{Helpshift.configuration.base_domain}/v1/#{Helpshift.configuration.customer_domain}/apps/",
                           :body => '[{"platform_ids":["blabla_platform_1337-123","blabla_platform_123-456"],"publish_id":"13","title":"Blabla Game 1"},
                                      {"platform_ids":["blabla_platform_007-008","blabla_platform_000-111"],"publish_id":"42","title":"Blabla Game 2"}]' )

      apps_array = Helpshift::App.all

      assert_equal 2, apps_array.size

      first_item_from_array = apps_array[0]

      assert first_item_from_array.instance_of? Helpshift::App
      assert_equal "Blabla Game 1", first_item_from_array.title
      assert_equal "13", first_item_from_array.publish_id
    end

    should 'fetch one specific app by id' do
      app_publish_id = 1337
      FakeWeb.register_uri(:get, "https://api.#{Helpshift.configuration.base_domain}/v1/#{Helpshift.configuration.customer_domain}/apps/#{app_publish_id}",
                           :body => '{"platform_ids":["bla_platform_987654321-123456789"],'+
                                      '"updated_at":1000000000000,'+
                                      '"created_at":1000000000000,'+
                                      '"title":"Game Name",'+
                                      '"id":"moew_app_123456789-987654321",'+
                                      '"publish_id":"1337"}')

      found_app = Helpshift::App.find(app_publish_id)

      assert found_app.instance_of? Helpshift::App
      assert_equal "Game Name", found_app.title
      assert_equal String(app_publish_id), found_app.publish_id
    end
  end
end
