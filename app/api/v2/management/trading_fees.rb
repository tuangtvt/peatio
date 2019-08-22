# encoding: UTF-8
# frozen_string_literal: true

module API
  module V2
    module Management
      class TradingFees < Grape::API
        desc 'Creates new trading fees table' do
          @settings[:scope] = :write_trading_fees
        end
        params do
          requires :maker,
                   type: BigDecimal,
                   desc: 'Maker fee.'
          requires :taker,
                   type: BigDecimal,
                   desc: 'Taker fee'
          optional :group,
                   type: String,
                   default: ::TradingFee::ANY,
                   desc: 'Member group'
          optional :market_id,
                   type: String,
                   default: ::TradingFee::ANY,
                   desc: 'Market id',
                   values: { value: -> { ::Market.ids.append(::TradingFee::ANY) },
                             message: 'Market does not exist' }
        end
        post '/fee_schedule/trading_fees/new' do
          trading_fee = ::TradingFee.new(declared(params))
          if trading_fee.save
            present trading_fee, with: API::V2::Admin::Entities::TradingFee
            status 201
          else
            body errors: trading_fees.errors.full_messages
            status 422
          end
        end

        desc 'Returns trading_fees table as paginated collection' do
          @settings[:scope] = :read_trading_fees
        end
        params do
          optional :group,
                   type: String,
                   desc: 'Member group'
          optional :market_id,
                   type: String,
                   desc: 'Market id',
                   values: { value: -> { ::Market.ids.append(::TradingFee::ANY) },
                             message: 'Market does not exist' }
          optional :page, type: Integer, default: 1, integer_gt_zero: true, desc: 'The page number (defaults to 1).'
          optional :limit, type: Integer, default: 100, range: 1..1000, desc: 'The number of objects per page (defaults to 100, maximum is 1000).'
        end
        post '/fee_schedule/trading_fees' do
          TradingFee
            .order(id: :desc)
            .tap { |t| t.where!(market_id: params[:market_id]) if params[:market_id] }
            .tap { |t| t.where!(group: params[:group]) if params[:group] }
            .tap { |q| present paginate(q), with: API::V2::Admin::Entities::TradingFee }
          status 200
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
