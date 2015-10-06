module HelpshiftGem

    class Issue
      attr_accessor :email, :title, :message_body, :platform_type, :app_id, :tags, :meta

      def is_valid?
        !@email.nil? && !@title.nil? && !@message_body.nil?
      end
    end
end
