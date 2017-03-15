module SNT
  module PMS
    class Configuration
      attr_accessor :url, :authentication_token, :ca_file

      def authentication_token
        raise Errors::Configuration, 'SNT::PMS authentication_token missing!' unless @authentication_token
        @authentication_token
      end

      def url
        raise Errors::Configuration, 'SNT::PMS url missing!' unless @url
        @url
      end
    end
  end
end
