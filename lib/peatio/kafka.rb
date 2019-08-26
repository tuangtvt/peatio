# encoding: UTF-8
# frozen_string_literal: true

require 'peatio/kafka/config'

module Peatio
  module Kafka
    class << self
      # NOTE: We use connections pool for producers since they may be shared
      # between puma threads.
      def producer
        @producer_wrapper ||=
          ::ConnectionPool::Wrapper.new(size: config.pool) do
            connection.producer
          end
      end

      # TODO:
      # All available consumer options are:
      # group_id
      # offset_commit_interval
      # offset_commit_threshold
      # session_timeout
      # heartbeat_interval
      # offset_retention_time
      # fetcher_max_queue_size
      #
      # NOTE: We don't need connection pool for consumers since each consumer is
      # designed for running in separate process so we don't need pool of
      # consumers.
      def consumer(topics:, group_id: 'peatio')
        consumer = connection.consumer(group_id: group_id)

        topics.map(&:to_s).each { |t| consumer.subscribe(t) }
        consumer
      end

      def connection
        ::Kafka.new(
          seed_brokers: config.seed_brokers,
          client_id: config.client_id
        )
      end

      def config
        @config ||= Peatio::Kafka::Config.new
      end

      def avro
        @avro ||=
          if Rails.env.production?
            # TODO: In prod use schema registry.
            AvroTurf.new(schemas_path: Rails.root.join('config/avro/schemas'))
          else
            AvroTurf.new(schemas_path: Rails.root.join('config/avro/schemas'))
          end
      end

      # Method for testing connection pool.
      def check
        Array.new(10) do
          Thread.new do
            Peatio::Kafka.producer.long
          end
        end.map(&:join)
        Kernel.puts "Real pool size now is #{Peatio::Kafka.producer.pool_real_size}"
      end
    end
  end
end

# Methods for testing connection pool.
Kafka::Client.define_method(:long) do
  sleep 1 + rand(0..1.0)
end

Kafka::Producer.define_method(:long) do
  sleep 1 + rand(0..1.0)
end

::ConnectionPool::Wrapper.define_method(:pool_real_size) do
  @pool.instance_variable_get(:@available).instance_variable_get(:@created)
end
