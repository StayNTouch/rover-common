module SNT
  module PMS
    module RPC
      class Group < Base
        class << self
          # ::SNT::PMS::RPC::Group.find(42737)
          def find(id)
            api.call('find', id, namespace: :group)
          end

          # Query should contain hotel_id
          # ::SNT::PMS::RPC::Group.list(80)
          def list(hotel_id, params = {})
            api.call('list', [ hotel_id, params ], namespace: :group)
          end
        end
      end
    end
  end
end
