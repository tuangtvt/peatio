# encoding: UTF-8
# frozen_string_literal: true

module Peatio
  module Kafka
    # TODO: Load config automatically from config/kafka.yml.
    class Config
      attr_accessor :seed_brokers, :client_id, :pool

      def initialize(seed_brokers: ['localhost:9092'], client_id: 'peatio', pool: 5)
        @seed_brokers = seed_brokers
        @client_id = client_id
        @pool = pool
      end
    end
  end
end
