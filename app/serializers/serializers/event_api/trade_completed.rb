# encoding: UTF-8
# frozen_string_literal: true

module Serializers
  module EventAPI
    class TradeCompleted
      def call(trade)
        # This serializer is the same as Trade#as_json_for_kafka.
        # Squash them if we will use kafka publish as Event API middleware.
        { # Trade
          id:         trade.id,
          price:      trade.price,
          amount:     trade.amount,
          total:      trade.total,
          created_at: trade.created_at.to_i,
          # Market
          market_id:             trade.market_id,
          market_base_currency:  trade.market.base_currency,
          market_quote_currency: trade.market.quote_currency,
          # Maker
          maker_order_id:         trade.maker_order_id,
          maker_uid:              trade.maker.uid,
          maker_side:             trade.maker_order.side,
          maker_type:             trade.maker_order.ord_type,
          maker_income_amount:    trade.order_income(maker_order),
          maker_income_currency:  trade.maker_order.income_currency_id,
          maker_outcome_amount:   trade.order_outcome(maker_order),
          maker_outcome_currency: trade.maker_order.outcome_currency_id,
          maker_fee_amount:       trade.order_fee_amount(maker_order),
          maker_fee_percentage:   trade.maker_order.maker_fee * 100,
          maker_fee_currency:     trade.maker_order.income_currency_id,
          maker_order_created_at: trade.maker_order.created_at.to_i,
          # Taker
          taker_order_id:         trade.taker_order_id,
          taker_uid:              trade.taker.uid,
          taker_side:             trade.taker_order.side,
          taker_type:             trade.taker_order.ord_type,
          taker_income_amount:    trade.order_income(taker_order),
          taker_income_currency:  trade.taker_order.income_currency_id,
          taker_outcome_amount:   trade.order_outcome(taker_order),
          taker_outcome_currency: trade.taker_order.outcome_currency_id,
          taker_fee_amount:       trade.order_fee_amount(taker_order),
          taker_fee_percentage:   trade.taker_order.taker_fee * 100,
          taker_fee_currency:     trade.taker_order.income_currency_id,
          taker_order_created_at: trade.taker_order.created_at.to_i,
        }
      end

      class << self
        def call(trade)
          new.call(trade)
        end
      end
    end
  end
end
