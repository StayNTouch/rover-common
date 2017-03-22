module SNT
  module PMS
    module RPC
      module DataTypes
        class Base
          attr_accessor :error

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
            attr_reader :attributes, :fields

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

            def api
              SNT::PMS::API::RPC
            end
          end
        end

        class Account < Base
          attr_accessor :account_number,
                        :address,
                        :ar_detail,
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

            # TODO
            def where(_query = {})
              raise NotImplementedError
              # payload = api.get('ext/accounts', query)
              #
              # raise payload[:error] if payload[:error]
              #
              # payload[:body]['results'].inject([]) do |objects, obj|
              #   # Select the attributes from the attributes key
              #   object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h
              #
              #   objects << new(object_attributes)
              # end
            end
          end
        end

        class ArBill < Base
          attr_accessor :account,
                        :ar_transactions,
                        :current_balance,
                        :hotel,
                        :id,
                        :bill_number,
                        :invoice_number

          class << self
            def all
              where
            end

            def where(query = {})
              # Add RPC namespace
              query[:namespace] = :accounting

              payload = api.call('ar_bills_updated_at', query, timeout: 60)

              raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.key?('errors')

              hotel = Hotel.new(payload['results']['hotel'])

              payload['results']['bills'].each_with_object([]) do |obj, objects|
                # Select the attributes from the attributes key
                object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

                # Add hotel to attributes
                object_attributes[:hotel] = hotel

                objects << new(object_attributes)
              end
            end
          end
        end

        class ArPaymentTransaction < Base
          attr_accessor :account,
                        :bill,
                        :credit,
                        :date,
                        :debit,
                        :hotel,
                        :id,
                        :paid_on

          class << self
            def all
              where
            end

            # query: hotel_code, date
            def where(query = {})
              # Add RPC namespace
              query[:namespace] = :accounting

              payload = api.call('ar_payment_transactions', query, timeout: 60)

              raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.key?('errors')

              hotel = Hotel.new(payload['results']['hotel'])

              payload['results']['ar_transactions'].each_with_object([]) do |obj, objects|
                # Select the attributes from the attributes key
                object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

                # Add hotel to attributes
                object_attributes[:hotel] = hotel

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

            # charge_codes = ::SNT::PMS::RPC::ChargeCode.where(hotel_code: @property.code, date: date)
            def where(query = {})
              # Add RPC namespace
              query[:namespace] = :accounting

              payload = api.call('charge_code_journals', query, timeout: 60)

              raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.key?('errors')

              hotel = Hotel.new(payload['results']['hotel'])

              payload['results']['charge_codes'].inject([]) do |objects, obj|
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

            # TODO
            def where(_query = {})
              raise NotImplementedError
              #
              # payload = api.get("ext/daily_balances/#{query.delete(:date)}", query)
              #
              # raise payload[:error] if payload[:error]
              #
              # new(payload[:body]['results'])
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

            # ::SNT::PMS::RPC::DataTypes::ExternalMapping.where(interface: 'accountview', hotel_code: 'GHLD')
            def where(query = {})
              # Add RPC namespace
              query[:namespace] = :mapping

              payload = api.call('interface', query, timeout: 30)

              raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.key?('errors')

              payload['results'].inject([]) do |objects, obj|
                # Select the attributes from the attributes key
                object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h

                objects << new(object_attributes)
              end
            end
          end
        end

        class FinancialTransaction < Base
          class << self
            def find(id)
              api.call('find', { namespace: :financial_transaction, id: id }, timeout: 30)
            end
          end
        end

        class Group < Base
          class << self
            def find(id)
              api.call('find', { namespace: :group, id: id }, timeout: 30)
            end
          end
        end

        class GroupHoldStatus < Base
          class << self
            # Query should contain hotel_id
            # ::SNT::PMS::RPC::GroupHoldStatus.where(hotel_id: 'id')
            def where(query = {})
              # Add RPC namespace
              query[:namespace] = :group_hold_status

              api.call('list', query, timeout: 30)
            end
          end
        end

        # Interface to PMS hotel API
        # ::SNT::PMS::RPC::Hotel.find_by_code('code')
        class Hotel < Base
          # TODO
          def save
            raise NotImplementedError
          end

          class << self
            def find(id)
              payload = api.call('find', { namespace: :hotel, id: id }, timeout: 30)

              raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.is_a?(Hash) && payload.key?('errors')

              payload
            end

            def find_by_code(code)
              payload = api.call('find_by_code', { namespace: :hotel, code: code }, timeout: 30)

              raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.is_a?(Hash) && payload.key?('errors')

              payload
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
            def interface(name, query = {})
              query[:interface] = name

              payload = api.call('hotel_interface', query, timeout: 30)

              raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.is_a?(Hash) && payload.key?('errors')

              object_attributes = payload.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h.tap do |o|
                o[:interface] = name
              end

              new(object_attributes)
            end

            def where(query = {})
              payload = api.call('hotel_interfaces', query, timeout: 30)

              raise SNT::PMS::Errors::PMSError, payload['errors'] if payload.is_a?(Hash) && payload.key?('errors')

              payload.inject([]) do |objects, obj|
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

            # TODO
            def where(_query = {})
              raise NotImplementedError
              #
              # payload = api.get('ext/financial_transactions/payments', query)
              #
              # raise payload[:error] if payload[:error]
              #
              # payload[:body]['results'].inject([]) do |objects, obj|
              #   # Select the attributes from the attributes key
              #   object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h
              #
              #   objects << new(object_attributes)
              # end
            end
          end
        end

        # Interface to PMS Reservation API
        class Reservation < Base
          class << self
            # ::SNT::PMS::RPC::Reservation.find('id')
            def find(id)
              api.call('find', { namespace: :reservation, id: id }, timeout: 30)
            end

            # Query should contain hotel_id
            # ::SNT::PMS::RPC::Reservation.where(hotel_id: 'id')
            def where(query = {})
              # Add RPC namespace
              query[:namespace] = :reservation

              api.call('list', query, timeout: 6000)
            end
          end
        end

        class ReservationDailyInstance < Base
          class << self
            def find(id)
              api.call('find', { namespace: :reservation_daily_instance, id: id }, timeout: 30)
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

            # TODO
            def where(_query = {})
              raise NotImplementedError
              #
              # payload = api.get('ext/financial_transactions/revenue', query)
              #
              # raise payload[:error] if payload[:error]
              #
              # payload[:body]['results'].inject([]) do |objects, obj|
              #   # Select the attributes from the attributes key
              #   object_attributes = obj.map { |k, v| [k.tr('-', '_').to_sym, v] }.to_h
              #
              #   objects << new(object_attributes)
              # end
            end
          end
        end

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
            # TODO
            def find(_hotel_code, _id)
              raise NotImplementedError
              #
              # payload = api.get("ext/reservations/#{id}/text_message", hotel_code: hotel_code)
              #
              # raise payload[:error] if payload[:error]
              #
              # new(payload[:body].deep_symbolize_keys)
            end
          end
        end
      end
    end
  end
end
