module HelpshiftGem
  class Issue
    attr_accessor :email, :title, :message_body, :platform_type, :app_id, :tags, :meta

    def create
      if !is_valid?
        raise 'Invalid issue. Are you missing field declarations for email, title or message_body?'
      else
        request_uri = "https://#{HelpshiftGem.configuration.customer_domain}.#{HelpshiftGem.configuration.base_domain}/v1/wooga/apps/#{app_publish_id}"
        response = RestClient.get request_uri,
          {
            "user"          => HelpshiftGem.configuration.api_key,
            "email"         => email,
            "title"         => title,
            "message-body"  => message_body,
            "platform-type" => platform_type,
            "app-id"        => app_id,
            "tags"          => tags,
            "meta"          => meta
          }
        JSON.parse response.to_str
      end
    end

    def is_valid?
      !@email.nil? && !@title.nil? && !@message_body.nil?
    end

  end
end
