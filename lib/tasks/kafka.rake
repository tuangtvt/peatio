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

    desc 'Produce sample messages to Kafka encoded with Avro'
    task aproducer: :environment do
      avro = AvroTurf.new(schemas_path: Rails.root.join('config/avro/schemas'))

      producer = Peatio::Kafka.producer

      100.times do |i|
        h = {
          double: rand,
          price: rand,
        }

        avro.encode(h, schema_name: 'Trade')

        producer.produce(msg, topic: 'sample')
        Kernel.puts msg
      end
      producer.deliver_messages
    end

    desc 'Consume sample messages from Kafka and decode with Avro'
    task aconsumer: :environment do
      consumer = Peatio::Kafka.consumer(topics: %i[sample])

      trap("TERM") { consumer.stop }

      consumer.each_message do |message|
        Kernel.puts "offset: #{message.offset}, key: #{message.key}, value: #{message.value}"
      end
    end
  end
end
