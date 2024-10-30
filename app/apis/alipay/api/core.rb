# frozen_string_literal: true

module Alipay
  module Api
    module Core
      BASE = 'https://openapi.alipay.com/v3/'


      def trade_pay
        post 'alipay/trade/pay'
      end

      API = {
        trade_query: {
          method: 'alipay.trade.query',
          required: [:out_trade_no],
          default: {}
        },
        open_auth_token_app: {
          method: 'alipay.open.auth.token.app',
          required: [:grant_type],
          default: { grant_type: 'authorization_code' }
        },
        system_oauth_token: {
          method: 'alipay.system.oauth.token',
          required: [],
          default: {}
        },
        user_info_share: {
          method: 'alipay.user.info.share',
          required: [],
          default: {}
        },
        trade_refund: {
          method: 'alipay.trade.refund',
          default: {},
          required: [:out_trade_no, :refund_amount]
        }
      }

    end
  end
end
