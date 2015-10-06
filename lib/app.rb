module HelpshiftGem
  class App

    attr_accessor :platform_ids, :updated_at, :created_at, :title, :id, :publish_id

    def self.all
      request_uri = "https://#{HelpshiftGem.configuration.customer_domain}.#{HelpshiftGem.configuration.base_domain}/v1/wooga/apps/"
      response = RestClient.get request_uri, { :user => HelpshiftGem.configuration.api_key }
      apps_array = JSON.parse response.to_str
      apps_array.map do |app|
        App.new(app)
      end
    end

    def self.find(app_publish_id)
      request_uri = "https://#{HelpshiftGem.configuration.customer_domain}.#{HelpshiftGem.configuration.base_domain}/v1/wooga/apps/#{app_publish_id}"
      response = RestClient.get request_uri, { :user => HelpshiftGem.configuration.api_key }
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
