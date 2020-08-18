# encoding: UTF-8
# frozen_string_literal: true

module Workers
  module Daemons
    class WithdrawAudit < Base

      self.sleep_time = 5

      def process
        Withdraw.submitted.each do |withdraw|
          withdraw.audit!
        rescue StandardError => e
          raise e if is_db_connection_error?(e)

          puts "Error on withdraw audit: #{$!}"
          puts $!.backtrace.join("\n")
        end

        Withdraw.requested.each do |withdraw|
          puts withdraw.as_json_for_event_api
          withdraw.auto_cancel!
        rescue StandardError => ex
          puts "Error on auto cancel: #{ex.inspect}"
        end

      end
    end
  end
end
