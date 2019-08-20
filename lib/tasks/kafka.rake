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
end
