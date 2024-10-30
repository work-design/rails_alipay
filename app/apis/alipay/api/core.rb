# frozen_string_literal: true

module Alipay
  module Api
    class Core
      BASE = 'https://openapi.alipay.com/v3/'

      def trade_pay
        post 'alipay/trade/pay', base: BASE
      end

      def initialize(app)
        @app = app
        @client = HTTPX.with(
          ssl: {
            verify_mode: OpenSSL::SSL::VERIFY_NONE
          },
          headers: {
            'Accept' => 'application/json'
          }
        )
      end

      def post(path, origin: nil, params: {}, headers: {}, debug: nil, **payload)
        with_options = { origin: origin }
        with_options.merge! debug: Rails.logger.instance_values['logdev'].dev, debug_level: 2 if debug

        with_common_headers('POST', path, params: payload.to_json, headers: headers) do |signed_headers|
          response = @client.with_headers(signed_headers).with(with_options).post(path, params: params, json: payload)
          debug ? response : response.json
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

        headers.merge!(
          authorization: Sign::Rsa2.sign(@app.private_rsa, content)
        )

        yield headers
      end

    end
  end
end
