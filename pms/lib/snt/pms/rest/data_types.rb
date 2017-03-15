module SNT
  module PMS
    module REST
      module DataTypes
        class Base
          attr_accessor :error, :url, :authentication_token

          def initialize(params = {})
            params.each do |k, v|
              instance_variable_set("@#{k.to_sym}", v) if attributes.include?(k.to_sym)
            end
          end

          def api
            @api ||= self.class.api
          end

          def attributes
            self.class.attributes
          end

          def fields
            self.class.fields
          end

          def success?
            @error.nil?
          end

          def assign_params(params)
            params.each do |k, v|
              instance_variable_set("@#{k.to_sym}", v) if attributes.include?(k.to_sym)
            end
          end

          def to_hash
            {}.tap do |hash|
              attributes.compact.each do |attribute|
                hash[attribute] = instance_variable_get("@#{attribute}")
              end
            end.compact
          end

          # Skip nil, empty array and empty hash.
          def skip_value?(value)
            value.nil? || ((value.is_a?(Array) || value.is_a?(Hash)) && value.empty?)
          end

          class << self
            def attr_accessor(*vars)
              @attributes ||= []
              @attributes.concat vars

              @fields ||= []
              @fields.concat vars

              super(*vars)
            end

            def attr_reader(*vars)
              @attributes ||= []
              @attributes.concat vars
              super(*vars)
            end

            def attributes
              @attributes
            end

            def api(*args)
              SNT::PMS::API::REST.new(*args)
            end

            def fields
              @fields
            end
          end
        end

        class Account < Base
          attr_accessor :account_number,
                        :address,
                        :ar_number,
                        :email,
                        :hotel,
                        :id,
                        :name,
                        :primary_contact,
                        :tax_number,
                        :type

          class << self
            def all
              where
            end

            def where(query = {})
              payload = api.get('ext/accounts', query)

              raise payload[:error] if payload[:error]

              payload[:body]['results'].inject([]) do |objects, obj|
                # Select the attributes from the attributes key
                object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

                objects << new(object_attributes)
              end
            end
          end
        end

        class ChargeCode < Base
          attr_accessor :charge_code,
                        :charge_code_type,
                        :description,
                        :financial_transactions,
                        :hotel

          class << self
            def all
              where
            end

            def where(query = {})
              payload = api.get('ext/charge_codes/financial_transactions', query)

              raise payload[:error] if payload[:error]

              hotel = Hotel.new(payload[:body]['results']['hotel'])

              payload[:body]['results']['charge_codes'].inject([]) do |objects, obj|
                # Select the attributes from the attributes key
                object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

                # Add hotel to attributes
                object_attributes[:hotel] = hotel

                objects << new(object_attributes)
              end
            end
          end
        end

        class DailyBalance < Base
          attr_accessor :ar,
                        :deposit,
                        :guest

          class << self
            def all
              where
            end

            def where(query = {})
              payload = api.get("ext/daily_balances/#{query.delete(:date)}", query)

              raise payload[:error] if payload[:error]

              new(payload[:body]['results'])
            end
          end

          def ledgers
            {
              ar: @ar,
              deposit: @deposit,
              guest: @guest
            }
          end
        end

        class ExternalMapping < Base
          attr_accessor :external_value,
                        :type,
                        :value

          class << self
            def all
              where
            end

            def where(query = {})
              payload = api.get("ext/hotels/settings/external_mappings/#{query.delete(:interface)}", query)

              raise payload[:error] if payload[:error]

              payload[:body]['results'].inject([]) do |objects, obj|
                # Select the attributes from the attributes key
                object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

                objects << new(object_attributes)
              end
            end
          end
        end

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

        class Payment < Base
          attr_accessor :account,
                        :amount,
                        :charge_code,
                        :date,
                        :description,
                        :hotel,
                        :id,
                        :parent_transaction_id
          class << self
            def all
              where
            end

            def where(query = {})
              payload = api.get('ext/financial_transactions/payments', query)

              raise payload[:error] if payload[:error]

              payload[:body]['results'].inject([]) do |objects, obj|
                # Select the attributes from the attributes key
                object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

                objects << new(object_attributes)
              end
            end
          end
        end

        class Revenue < Base
          attr_accessor :account,
                        :amount,
                        :charge_code,
                        :date,
                        :description,
                        :hotel,
                        :id,
                        :parent_transaction_id

          class << self
            def all
              where
            end

            def where(query = {})
              payload = api.get('ext/financial_transactions/revenue', query)

              raise payload[:error] if payload[:error]

              payload[:body]['results'].inject([]) do |objects, obj|
                # Select the attributes from the attributes key
                object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

                objects << new(object_attributes)
              end
            end
          end
        end

        # ::SNT::PMS::REST::TextMessage.find('ZAMS', 1347334)
        class TextMessage < Base
          attr_accessor :check_in_date,
                        :check_in_time,
                        :check_out_date,
                        :check_out_time,
                        :guest_email,
                        :guest_membership_number,
                        :guest_membership_status,
                        :guest_mobile_number,
                        :guest_name_first,
                        :guest_name_last,
                        :guest_profile_id,
                        :reservation_adults_count,
                        :reservation_children_count,
                        :reservation_confirmation_number,
                        :reservation_rate_code,
                        :reservation_room_code,
                        :reservation_status,
                        :room,
                        :room_pin

          class << self
            def find(hotel_code, id)
              payload = api.get("ext/reservations/#{id}/text_message", hotel_code: hotel_code)

              raise payload[:error] if payload[:error]

              new(payload[:body].deep_symbolize_keys)
            end
          end
        end
      end
    end
  end
end
