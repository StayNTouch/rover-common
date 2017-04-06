module SNT
  module PMS
    module REST
      class Interface < Base
        attr_accessor :access_token,
                      :authorized,
                      :balancing_account_code,
                      :client_id,
                      :client_secret,
                      :endpoint,
                      :emails,
                      :expires_in,
                      :facility_id,
                      :interface,
                      :journal_code,
                      :refresh_token,
                      :token_type,
                      :url

        class << self
          def all
            where
          end

          def where(query = {})
            payload = api.get('ext/hotels/settings/interfaces', query)

            raise payload[:error] if payload[:error]

            payload[:body]['results'].inject([]) do |objects, obj|
              # Select the attributes from the attributes key
              object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

              objects << new(object_attributes)
            end
          end
        end
      end
    end
  end
end

