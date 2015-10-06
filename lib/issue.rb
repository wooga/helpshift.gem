module HelpshiftGem
  class Issue
    attr_accessor :email, :title, :message_body, :app_id, :platform_type, :tags, :meta

    def create
      if !is_valid?
        raise 'Invalid issue. Are you missing field declarations for email, title or message_body?'
      else
        request_uri = "https://api.#{HelpshiftGem.configuration.base_domain}/v1/#{HelpshiftGem.configuration.customer_domain}/apps/#{app_id}"
        response = RestClient::Request.execute method: :get, url: request_uri, user: HelpshiftGem.configuration.api_key, payload: {
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
      !@email.nil? && !@title.nil? && !@message_body.nil? && !@app_id.nil?
    end

  end
end
