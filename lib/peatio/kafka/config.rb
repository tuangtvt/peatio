# encoding: UTF-8
# frozen_string_literal: true

module Peatio
  module Kafka
    class Config
      attr_accessor :seed_brokers, :client_id

      def initialize(seed_brokers: ['localhost:9092'], client_id: 'peatio')
        @seed_brokers = seed_brokers
        @client_id = client_id
      end
    end
  end
end
