# frozen_string_literal: true

namespace :kafka do
  namespace :sample do
    desc 'Publish example messages to Kafka'
    task publish: :environment do
      producer = Racecar.producer

      100.times do |i|
        producer.produce("hello #{i}", topic: 'sample')
      end
    end

    desc 'Consume example messages from Kafka'
    task consume: :environment do
      consumer = Racecar.consumer(group_id: 'sample-group', topics: %i[sample])

      trap("TERM") { consumer.stop }

      consumer.each_message do |message|
        Kernel.puts "Consumed message: #{message}"
      end
    end
  end
end
