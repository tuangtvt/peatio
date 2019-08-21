# encoding: UTF-8
# frozen_string_literal: true

module Peatio
  module Kafka
    class << self
      def config
        @config ||= Peatio::Kafka::Config.new
      end

      def producer
        connection.producer(compression_codec: config.producer_compression_codec)
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

      def consumer(topics:)
        consumer = connection.consumer(
          group_id: 'peatio'
        )

        topics.map(&:to_s).each do |topic|
          consumer.subscribe(topic)
        end
        consumer
        # kafka.consumer(
        #   group_id: config.group_id,
        #   offset_commit_interval: config.offset_commit_interval,
        #   offset_commit_threshold: config.offset_commit_threshold,
        #   session_timeout: config.session_timeout,
        #   heartbeat_interval: config.heartbeat_interval,
        #   offset_retention_time: config.offset_retention_time,
        #   fetcher_max_queue_size: config.max_fetch_queue_size,
        #   )
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
