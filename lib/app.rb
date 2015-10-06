module HelpshiftGem
  class App

    attr_accessor :platform_ids, :updated_at, :created_at, :title, :id, :publish_id

    def self.all
      request_uri = "https://api.#{HelpshiftGem.configuration.base_domain}/v1/#{HelpshiftGem.configuration.customer_domain}/apps/"
      response = RestClient::Request.execute method: :get, url: request_uri, user: HelpshiftGem.configuration.api_key
      puts response.to_str
      apps_array = JSON.parse response.to_str
      apps_array.map do |app|
        App.new(app)
      end
    end

    def self.find(app_publish_id)
      request_uri = "https://api.#{HelpshiftGem.configuration.base_domain}/v1/#{HelpshiftGem.configuration.customer_domain}/apps/#{app_publish_id}"
      response = RestClient::Request.execute method: :get, url: request_uri, user: HelpshiftGem.configuration.api_key
      App.new(JSON.parse response.to_str)
    end

    def initialize(json_object)
      @platform_ids = json_object["platform_ids"]
      @updated_at = json_object["updated_at"]
      @created_at = json_object["created_at"]
      @title = json_object["title"]
      @id = json_object["id"]
      @publish_id = json_object["publish_id"]
    end

  end
end
