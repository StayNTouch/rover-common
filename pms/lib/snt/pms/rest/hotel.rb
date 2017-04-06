module SNT
  module PMS
    module REST
      class Hotel < Base
        attr_accessor :access_token,
                      :authorized,
                      :currency,
                      :refresh_token,
                      :hotel_code

        def save
          payload = api.put('ext/hotels/settings/exact_token_update', to_hash)

          case payload[:response].code.to_i
            when 200
              true
            when 401
              @error = '401: Unauthorized request'
              false
            when 403
              @error = '403: Forbidden request'
              false
            else
              @error = "Unknown response code: #{payload[:response].code}"
              false
          end
        end
      end
    end
  end
end
