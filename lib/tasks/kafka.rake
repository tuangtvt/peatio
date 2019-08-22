# frozen_string_literal: true

namespace :kafka do
  namespace :sample do
    desc 'Produce sample messages to Kafka'
    task producer: :environment do
      producer = Peatio::Kafka.producer

      100.times do |i|
        msg = "hello #{i}"
        producer.produce(msg, topic: 'sample')
        Kernel.puts msg
      end
      producer.deliver_messages
    end

    desc 'Consume sample messages from Kafka'
    task consumer: :environment do
      consumer = Peatio::Kafka.consumer(topics: %i[sample])

      trap("TERM") { consumer.stop }

      consumer.each_message do |message|
        Kernel.puts "offset: #{message.offset}, key: #{message.key}, value: #{message.value}"
      end
    end
  end

  namespace :trades do
    desc 'Publish avro encoded trades to Kafka.'
    task produce: :environment do
      BATCH_SIZE = 500
      producer = Peatio::Kafka.producer
      avro = Peatio::Kafka.avro

      Trade
        .includes(:market, :maker, :maker_order, :taker, :taker_order)
        .find_in_batches(batch_size: BATCH_SIZE) do |trades_batch|
          trades_batch.each do |trade|
            data = avro.encode(trade.as_json_for_event_api, schema_name: trade.avro_schema_name)
            producer.produce(data, topic: 'trades')
          end
          Kernel.puts "Produced #{BATCH_SIZE} messages. Delivering..."
          Kernel.puts "buffer #{producer.buffer_bytesize}"
          producer.deliver_messages
          Kernel.puts "Delivered #{BATCH_SIZE} messages."
      end
    end
  end
end
