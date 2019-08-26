# frozen_string_literal: true

require 'peatio/kafka'

module Workers
  module AMQP
    # KafkaExporter forwards trade execution events from RabbitMQ to Kafka
    # topics for further processing.
    class KafkaExporter
      @producer = Peatio::Kafka.producer
      @avro = Peatio::Kafka.avro

      def process(payload)
        Rails.logger.debug { payload }

        data = avro.encode(trade.as_json_for_kafka, schema_name: trade.avro_schema_name)
        producer.produce(data, topic: 'trades')
      end
    end
  end
end
