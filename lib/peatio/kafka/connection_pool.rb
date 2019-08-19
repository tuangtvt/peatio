# encoding: UTF-8
# frozen_string_literal: true

module Peatio
  module Kafka
    class ConnectionPool
      def initialize(size = 5)
        config = Peatio::Kafka.config

        @pool ||= ::ConnectionPool::Wrapper.new(size: size) do
          ::Kafka.new(
            seed_brokers: config.seed_brokers,
            client_id: config.client_id
          )
        end
      end

      def connection
        @pool
      end
    end
  end
end
