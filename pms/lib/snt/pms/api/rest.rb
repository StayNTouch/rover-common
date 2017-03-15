module SNT
  module PMS
    module API
      class REST < Base
        # Get the configured service endpoint
        def service_endpoint
          configuration.url
        end

        def api_call(payload)
          payload[:header] = { 'Accept' => 'application/json; api_version=3',
                               'Api-Token' => configuration.authentication_token,
                               'Content-Type' => 'application/json' }

          payload[:uri] ||= uri.dup
          payload[:http] ||= http.dup

          format_request(payload)

          payload[:response] = http_call(payload)

          case payload[:response].code.to_i
          when 200...299
            # Do nothing, success
          when 401
            payload[:error] = '401: Unauthorized request'
          when 403
            payload[:error] = '403: Forbidden request'
          when 404
            payload[:error] = '404: Not Found'
          when 422
            payload[:error] = '422: Unprocessable Entity'
          when 500
            payload[:error] = '500: Internal Server Error'
          else
            payload[:error] = "Unknown response code: #{payload[:response].code}"
          end

          return payload if payload[:error]

          payload[:body] = JSON.parse(payload[:response].body)

          payload
        end

        def format_request(payload)
          payload[:uri].path = "#{payload[:uri].path}#{payload[:action]}"
          payload[:uri].query = URI.encode_www_form(payload[:query]) if payload[:query] && !payload[:query].empty?
          payload[:body] = payload[:params].to_json

          payload
        end

        def post(action, params = {})
          action, params = '', action, params if action.is_a? Hash
          api_call(method: :post, action: action, params: params)
        end

        def get(action, params = {})
          action, params = '', action, params if action.is_a? Hash
          api_call(method: :get, action: action, query: params)
        end

        def patch(action, params = {})
          action, params = '', action, params if action.is_a? Hash
          api_call(method: :patch, action: action, params: params)
        end

        def put(action, params = {})
          action, params = '', action, params if action.is_a? Hash
          api_call(method: :put, action: action, params: params)
        end

        def delete(action, params = {})
          action, params = '', action, params if action.is_a? Hash
          api_call(method: :delete, action: action, params: params)
        end
      end
    end
  end
end
