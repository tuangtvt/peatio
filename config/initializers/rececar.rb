# encoding: UTF-8
# frozen_string_literal: true

# TODO: Is it gonna be Racecar ? Because right now Racecar is used only for managing configs.
module Racecar
  class << self
    def producer
      pool.producer
    end


    def consumer(group_id:, topics:)
      binding.pry
      # Consumers with the same group id will form a Consumer Group together.
      consumer = pool.consumer(group_id: group_id)

      # It's possible to subscribe to multiple topics by calling `subscribe`
      # repeatedly.
      topics.each do |t|
        consumer.subscribe(t.to_s)
      end
      consumer
    end

    # This connection pool needs some love.
    # TODO: Add pool size to config.
    def pool
      @pool ||= ConnectionPool::Wrapper.new(size: 5) do
        Kafka.new(
          client_id: config.client_id,
          seed_brokers: config.brokers,
          logger: logger,
          connect_timeout: config.connect_timeout,
          socket_timeout: config.socket_timeout,
          ssl_ca_cert: config.ssl_ca_cert,
          ssl_ca_cert_file_path: config.ssl_ca_cert_file_path,
          ssl_client_cert: config.ssl_client_cert,
          ssl_client_cert_key: config.ssl_client_cert_key,
          sasl_plain_username: config.sasl_plain_username,
          sasl_plain_password: config.sasl_plain_password,
          sasl_scram_username: config.sasl_scram_username,
          sasl_scram_password: config.sasl_scram_password,
          sasl_scram_mechanism: config.sasl_scram_mechanism,
          sasl_over_ssl: config.sasl_over_ssl,
          ssl_ca_certs_from_system: config.ssl_ca_certs_from_system,
          ssl_verify_hostname: config.ssl_verify_hostname
        )
      end
    end
  end
end
