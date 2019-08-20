# encoding: UTF-8
# frozen_string_literal: true

module Peatio
  module Kafka
    class << self
      def config
        @config ||= Peatio::Kafka::Config.new
      end

      def connection
        connection_pool.connection
      end

      def connection_pool
        @connection_pool ||= Peatio::Kafka::ConnectionPool.new
      end
    end
  end
end
