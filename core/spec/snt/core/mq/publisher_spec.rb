require 'spec_helper'

RSpec.describe SNT::Core::MQ::Publisher do
  subject(:publisher) { described_class.new }

  # What the broker was asked to publish: [exchange name, routing key] per basic_publish call
  let(:published) { [] }
  let(:channel) { double('Bunny::Channel', open?: true, register_exchange: nil, nacked_set: []) }
  let(:logger) { ::Logger.new(nil) }

  before do
    # A real Bunny::Exchange on a fake channel, so Bunny's own Exchange#publish runs. It removes
    # :routing_key from the hash it is handed, which is what the publisher must survive.
    allow(channel).to receive(:default_exchange).and_return(::Bunny::Exchange.default(channel))
    allow(channel).to receive(:basic_publish) { |_payload, exchange, routing_key, _opts| published << [exchange, routing_key] }
    allow(channel).to receive(:wait_for_confirms).and_return(true)

    allow(::SNT::Core::MQ).to receive(:logger).and_return(logger)
    allow(::SNT::Core::MQ).to receive(:reconnect!)
    ::Thread.current[:bunny_channel] = channel
  end

  after { ::Thread.current[:bunny_channel] = nil }

  # After a connection drop the publisher clears the thread's channel and asks for a new one
  def stub_new_channel_after_reconnect
    connection = double('Bunny::Session')
    allow(connection).to receive(:create_channel).and_return(channel)
    allow(channel).to receive(:confirm_select)
    allow(::SNT::Core::MQ).to receive(:connection).and_return(connection)
  end

  describe '#publish' do
    it 'publishes to the default exchange with the to_queue as routing key' do
      expect(publisher.publish('{}', to_queue: 'ifc.ota.build_process')).to be(true)

      expect(published).to eq([['', 'ifc.ota.build_process']])
    end

    context 'when the connection is closed on the first attempt' do
      before do
        stub_new_channel_after_reconnect

        attempts = 0
        allow(channel).to receive(:basic_publish) do |_payload, exchange, routing_key, _opts|
          attempts += 1
          raise ::Bunny::ConnectionClosedError, ::AMQ::Protocol::Basic::Publish if attempts == 1

          published << [exchange, routing_key]
        end
      end

      it 'retries with the routing key given as to_queue' do
        expect(publisher.publish('{}', to_queue: 'ifc.ota.build_process')).to be(true)

        expect(::SNT::Core::MQ).to have_received(:reconnect!).once
        expect(published).to eq([['', 'ifc.ota.build_process']])
      end

      it 'retries with the routing key given as routing_key' do
        expect(publisher.publish('{}', routing_key: 'pms.events')).to be(true)

        expect(published).to eq([['', 'pms.events']])
      end
    end

    context 'when the connection is closed before the exchange is resolved' do
      before do
        stub_new_channel_after_reconnect

        attempts = 0
        allow(channel).to receive(:default_exchange) do
          attempts += 1
          raise 'this connection is not open. Was Bunny::Session#start invoked? Is automatic recovery enabled?' if attempts == 1

          ::Bunny::Exchange.default(channel)
        end
      end

      it 'retries with the original routing key' do
        expect(publisher.publish('{}', to_queue: 'ifc.ota.build_process')).to be(true)

        expect(published).to eq([['', 'ifc.ota.build_process']])
      end
    end

    context 'when the broker nacks the first attempt' do
      before { allow(channel).to receive(:wait_for_confirms).and_return(false, true) }

      it 'republishes with the original routing key' do
        expect(publisher.publish('{}', to_queue: 'ifc.ota.build_process')).to be(true)

        expect(published).to eq([['', 'ifc.ota.build_process'], ['', 'ifc.ota.build_process']])
      end
    end

    it "leaves the caller's options untouched" do
      options = { to_queue: 'ifc.ota.build_process', persistent: true }

      publisher.publish('{}', options)

      expect(options).to eq(to_queue: 'ifc.ota.build_process', persistent: true)
    end

    it 'converts a symbol routing key to a string' do
      publisher.publish('{}', routing_key: :'pms.events')

      expect(published).to eq([['', 'pms.events']])
    end
  end
end
