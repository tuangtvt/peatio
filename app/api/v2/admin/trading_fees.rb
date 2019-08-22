# encoding: UTF-8
# frozen_string_literal: true

module API
  module V2
    module Admin
      class TradingFees < Grape::API
        desc 'Returns trading_fees table as paginated collection',
          is_array: true,
          success: API::V2::Admin::Entities::TradingFee
        params do
          use :pagination
          use :ordering
        end
        post '/trading_fees' do
          authorize! :read, TradingFee

          result = TradingFee.order(params[:order_by] => params[:ordering])
          present paginate(result), with: API::V2::Admin::Entities::TradingFee
        end

        desc 'Creates new trading fees table',
          is_array: true,
          success: API::V2::Admin::Entities::TradingFee
        params do
          requires :maker,
                   type: { value: BigDecimal, message: 'admin.trading_fee.non_decimal_maker' },
                   values: { value: -> (p){ p && p >= 0 }, message: 'admin.trading_fee.invalid_maker' },
                   desc: -> { API::V2::Admin::Entities::TradingFee.documentation[:maker][:desc] }
          requires :taker,
                   type: { value: BigDecimal, message: 'admin.trading_fee.non_decimal_taker' },
                   values: { value: -> (p){ p && p >= 0 }, message: 'admin.trading_fee.invalid_taker' },
                   desc: -> { API::V2::Admin::Entities::TradingFee.documentation[:taker][:desc] }
          optional :group,
                   type: String,
                   default: ::TradingFee::ANY,
                   desc: -> { API::V2::Admin::Entities::TradingFee.documentation[:group][:desc] }
          optional :market_id,
                   type: String,
                   desc: -> { API::V2::Admin::Entities::TradingFee.documentation[:market_id][:desc] },
                   default: ::TradingFee::ANY,
                   values: { value: -> { ::Market.ids.append(::TradingFee::ANY) },
                             message: 'admin.trading_fee.market_doesnt_exist' }
        end
        post '/trading_fees/new' do
          authorize! :create, TradingFee

          trading_fee = ::TradingFee.new(declared(params))
          if trading_fee.save
            present trading_fee, with: API::V2::Admin::Entities::TradingFee
            status 201
          else
            body errors: trading_fees.errors.full_messages
            status 422
          end
        end

        desc 'Update trading fees table',
          is_array: true,
          success: API::V2::Admin::Entities::TradingFee
        params do
          requires :id,
                   type: { value: Integer, message: 'admin.trading_fee.non_integer_id' },
                   desc: -> { API::V2::Admin::Entities::TradingFee.documentation[:id][:desc] }
          optional :maker,
                   type: { value: BigDecimal, message: 'admin.trading_fee.non_decimal_maker' },
                   values: { value: -> (p){ p && p >= 0 }, message: 'admin.trading_fee.invalid_maker' },
                   desc: -> { API::V2::Admin::Entities::TradingFee.documentation[:maker][:desc] }
          optional :taker,
                   type: { value: BigDecimal, message: 'admin.trading_fee.non_decimal_taker' },
                   values: { value: -> (p){ p && p >= 0 }, message: 'admin.trading_fee.invalid_taker' },
                   desc: -> { API::V2::Admin::Entities::TradingFee.documentation[:taker][:desc] }
          optional :group,
                   type: String,
                   default: ::TradingFee::ANY,
                   desc: -> { API::V2::Admin::Entities::TradingFee.documentation[:group][:desc] }
          optional :market_id,
                   type: String,
                   desc: -> { API::V2::Admin::Entities::TradingFee.documentation[:market_id][:desc] },
                   values: { value: -> { ::Market.ids.append(::TradingFee::ANY) },
                             message: 'admin.trading_fee.market_doesnt_exist' }
        end
        post '/trading_fees/update' do
          authorize! :write, TradingFee

          trading_fee = ::TradingFee.find(params[:id])
          if trading_fee.update(declared(params, include_missing: false))
            present trading_fee, with: API::V2::Admin::Entities::TradingFee
          else
            body errors: trading_fee.errors.full_messages
            status 422
          end
        end



        # desc 'Creates new trading fees table' do
        #   @settings[:scope] = :write_trading_fees
        # end
        # params do
        #   requires :maker,
        #            type: BigDecimal,
        #            desc: 'Maker fee.'
        #   requires :taker,
        #            type: BigDecimal,
        #            desc: 'Taker fee'
        #   optional :group,
        #            type: String,
        #            desc: 'Member group'
        #   optional :market_id,
        #            type: String,
        #            desc: 'Market id',
        #            values: { value: -> { ::Market.ids },
        #            message: 'Market does not exist' }
        # end
        # post '/fee_schedule/trading_fees/' do
        #   trading_fee = ::TradingFee.new(declared(params))
        #   if trading_fee.save
        #     present trading_fee, with: API::V2::Admin::Entities::TradingFee
        #     status 201
        #   else
        #     body errors: trading_fees.errors.full_messages
        #     status 422
        #   end
        # end
      end
    end
  end
end
