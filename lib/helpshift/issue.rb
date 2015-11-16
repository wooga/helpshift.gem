module Helpshift
  class Issue
    attr_accessor(:email, :title, :message_body, :app_id,
                  :platform_type, :tags, :meta)

    def create
      if !is_valid?
        raise "Invalid issue. Are you missing field declarations for " +
          "email, title, message_body, app_id or platform_type('ios', 'android' or 'web')? " +
          "Is tags an Array? Is meta a Hash?"
      else
        request_uri = "https://api.#{Helpshift.configuration.base_domain}/"+
          "v1/#{Helpshift.configuration.customer_domain}/issues"

        params = {
          "email"         => email,
          "title"         => title,
          "message-body"  => message_body,
          "app-id"        => app_id,
          "platform-type" => platform_type,
          "tags"          => tags.to_json,
          "meta"          => meta.to_json
        }

        params.each { |name,value| params.delete(name) if value.nil? }

        RestClient::Request.
          execute(:method      => :post,
                  :url         => request_uri,
                  :payload     => params,
                  :user        => Helpshift.configuration.api_key,
                  :ssl_version => :SSLv23)
      end
    end

    def is_valid?
      (!@platform_type.nil? &&
       ["ios", "android", "web"].include?(@platform_type)) &&
        (!@tags.nil? && @tags.is_a?(Array)) &&
        (!@meta.nil? && @meta.is_a?(Hash)) &&
        !@email.nil? && !@title.nil? && !@message_body.nil? && !@app_id.nil?
    end
  end
end
