require 'net/https'
require 'uri'

module SNT
  module PMS
    module API
      class Base
        attr_accessor :http, :uri

        def configuration
          SNT::PMS.configuration
        end

        # Create HTTP connection based on given service name or configured end point
        def create_http_connection(uri)
          Net::HTTP.new(uri.host, uri.port).tap do |https|
            if uri.scheme == 'https'
              https.use_ssl = true
              https.ca_file = configuration.ca_file unless configuration.ca_file.nil?
            end
          end
        end

        def http
          @http ||= create_http_connection(uri)
        end

        # Make Http call
        def http_call(payload)
          http = create_http_connection(payload[:uri])

          http.start do |session|
            if [:get, :delete, :head].include? payload[:method]
              session.send(payload[:method], payload[:uri].request_uri, payload[:header])
            else
              session.send(payload[:method], payload[:uri].request_uri, payload[:body], payload[:header])
            end
          end
        end

        def uri
          @uri ||=
            begin
              uri = URI.parse("#{service_endpoint}/")
              uri.path = uri.path.gsub(/\/+/, '/')
              uri
            end
        end
      end
    end
  end
end
