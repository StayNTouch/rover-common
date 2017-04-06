module SNT
  module PMS
    module REST
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
