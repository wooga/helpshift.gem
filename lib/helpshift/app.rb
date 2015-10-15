module Helpshift
  class App
    attr_accessor(:platform_ids, :updated_at, :created_at, :title,
                  :id, :publish_id)

    def self.all
      request_uri = "https://api.#{Helpshift.configuration.base_domain}/"+
        "v1/#{Helpshift.configuration.customer_domain}/apps/"

      response = do_request(request_uri)

      JSON.parse(response.to_str).map { |app| App.new(app) }
    end

    def self.find(app_publish_id)
      request_uri = "https://api.#{Helpshift.configuration.base_domain}/"+
        "v1/#{Helpshift.configuration.customer_domain}/apps/#{app_publish_id}"

      response = do_request(request_uri)

      App.new(JSON.parse(response.to_str))
    end

    def initialize(json_object)
      json_object.each { |key, val| send("#{key}=", val) }
    end

    private

    def self.do_request(request_uri)
      RestClient::Request.
        execute(:method      => :get,
                :url         => request_uri,
                :user        => Helpshift.configuration.api_key,
                :ssl_version => :SSLv23)
    end
  end
end
