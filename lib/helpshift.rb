require 'rest-client'
require 'json'

module HelpshiftGem
  class Helpshift

    def self.apps_data
      request_uri = "https://#{HelpshiftGem.configuration.customer_domain}.#{HelpshiftGem.configuration.base_domain}/v1/wooga/apps/"
      response = RestClient.get request_uri, { :user => HelpshiftGem.configuration.api_key }
      JSON.parse response.to_str
    end

    def self.app_data(app_publish_id)
      request_uri = "https://#{HelpshiftGem.configuration.customer_domain}.#{HelpshiftGem.configuration.base_domain}/v1/wooga/apps/#{app_publish_id}"
      response = RestClient.get request_uri, { :user => HelpshiftGem.configuration.api_key }
      JSON.parse response.to_str
    end

    def self.create_issue(issue)
      if !issue.is_valid?
        raise 'Invalid issue. Are you missing field declarations for email, title or message_body?'
      else
        request_uri = "https://#{HelpshiftGem.configuration.customer_domain}.#{HelpshiftGem.configuration.base_domain}/v1/wooga/apps/#{app_publish_id}"
        response = RestClient.get request_uri,
          {
            "user"          => HelpshiftGem.configuration.api_key,
            "email"         => issue.email,
            "title"         => issue.title,
            "message-body"  => issue.message_body,
            "platform-type" => issue.platform_type,
            "app-id"        => issue.app_id,
            "tags"          => issue.tags,
            "meta"          => issue.meta
          }
        JSON.parse response.to_str
      end
    end

  end
end
