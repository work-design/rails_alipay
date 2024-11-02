# frozen_string_literal: true

module Alipay
  module Api
    class Core
      BASE = 'https://openapi.alipay.com/v3/'

      def trade_pay(**options)
        post 'alipay/trade/pay', origin: BASE, **options
      end

      def trade_refund(**options)
        post 'alipay/trade/refund', origin: BASE, **options
      end

      def initialize(app)
        @app = app
      end

      def post(path, origin: nil, params: {}, headers: {}, debug: nil, **payload)
        with_common_headers('POST', path, params: payload.to_json, headers: headers) do |signed_headers|
          response = Net::HTTP.post(URI("#{origin}#{path}"), payload.to_json, signed_headers)
          JSON.parse(response.body)
        end
      end

      def with_common_headers(method, path, params: {}, headers: {})
        r = {
          app_id: @app.appid,
          nonce: SecureRandom.hex,
          timestamp: Time.current.to_ms
        }
        auth_string = r.map(&->(k, v){ "#{k}=#{v}" }).join(',')
        content = [
          auth_string,
          method,
          "/v3/#{path}",
          params,
          ''
        ].join("\n")
        signature = Sign::Rsa2.sign(@app.private_key, content)

        headers.merge!(
          'content-type': 'application/json',
          authorization: "ALIPAY-SHA256withRSA #{auth_string},sign=#{signature}"
        )

        yield headers
      end

    end
  end
end
