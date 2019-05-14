require_relative '../test_helper.rb'

class AppTest < Minitest::Test
  context "app" do
    should 'fetch list of all apps' do
      fake_response = [{"platform_ids" => ["blabla_platform_1337-123",
                                           "blabla_platform_123-456"],
                       "publish_id"    => 13,
                       "title"         => "Blabla Game 1"},
                       {"platform_ids" => ["blabla_platform_007-008",
                                           "blabla_platform_000-111"],
                       "publish_id"    => 42,
                       "title"         => "Blabla Game 2"}]

        stub_request(:get,
                     "https://api."+
                     "#{Helpshift.configuration.base_domain}/v1/"+
                     "#{Helpshift.configuration.customer_domain}/apps/").to_return(
                       :body => fake_response.to_json)

      apps_array = Helpshift::App.all

      assert_equal 2, apps_array.size

      fake_response.zip(apps_array).each do |expected_item, actual_item|
        assert(actual_item.instance_of?(Helpshift::App),
               "Failed for #{expected_item}")
        expected_item.each do |key, value|
          assert_equal value, actual_item.send(key), "Failed for #{key}"
        end
      end
    end

    should 'fetch one specific app by id' do
      app_publish_id = 1337

      fake_response_object = {
        :platform_ids => ["bla_platform_987654321-123456789"],
        :updated_at   => Time.now.to_i,
        :created_at   => (Time.now - (3600 * 24)).to_i,
        :title        => "Game Name",
        :id           => "moew_app_123456789-987654321",
        :publish_id   => app_publish_id
      }

      stub_request(:get, "https://api."+
                   "#{Helpshift.configuration.base_domain}/v1/"+
                   "#{Helpshift.configuration.customer_domain}/apps/"+
                   "#{app_publish_id}").to_return(
                     :body => fake_response_object.to_json )

      found_app = Helpshift::App.find(app_publish_id)

      fake_response_object.each do |key, value|
        assert_equal value, found_app.send(key), "Failed for #{key}"
      end
      assert found_app.instance_of?(Helpshift::App)
    end

    should 'ignore unknown attributes' do
      app_publish_id = 1337

      fake_response_object = {
        :platform_ids => ["bla_platform_987654321-123456789"],
        :updated_at   => Time.now.to_i,
        :created_at   => (Time.now - (3600 * 24)).to_i,
        :title        => "Game Name",
        :id           => "moew_app_123456789-987654321",
        :publish_id   => app_publish_id,
        :new_attribute => :value,
      }

      stub_request(:get, "https://api."+
                     "#{Helpshift.configuration.base_domain}/v1/"+
                     "#{Helpshift.configuration.customer_domain}/apps/"+
                     "#{app_publish_id}").to_return(
                     :body => fake_response_object.to_json )

     found_app = Helpshift::App.find(app_publish_id)

     fake_response_object.each do |key, value|
       if key != :new_attribute
         assert_equal value, found_app.send(key), "Failed for #{key}"
       end
     end
    end
  end
end
