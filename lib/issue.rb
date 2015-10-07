module HelpshiftGem
  class Issue
    attr_accessor :email, :title, :message_body, :app_id, :platform_type, :tags, :meta

    def create
      if !is_valid?
        raise 'Invalid issue. Are you missing field declarations for "email", "title" or "message_body"? Is "tags" an Array? Is "meta" a Hash?'
      else
        request_uri = "https://api.#{HelpshiftGem.configuration.base_domain}/v1/#{HelpshiftGem.configuration.customer_domain}/issues"
        params = {
          "email"         => email,
          "title"         => title,
          "message-body"  => message_body,
          "app-id"        => app_id,
          "platform-type" => platform_type,
          # These to keys cause the API to return "400 Bad Request", so we leave them out for now:
          # "tags"          => tags,
          # "meta"          => meta
        }
        params.each {|key,value| params.delete(key) if value.nil? }

        RestClient.post request_uri, params, {:Authorization => "Basic #{Base64.encode64(HelpshiftGem.configuration.api_key)}"}
      end
    end

    def is_valid?
      (@platform_type.nil? || ["ios", "android", "web"].include?(@platform_type)) &&
      (@tags.nil? || @tags.is_a?(Array)) &&
      (@meta.nil? || @meta.is_a?(Hash)) &&
      !@email.nil? && !@title.nil? && !@message_body.nil? && !@app_id.nil?
    end

  end
end
