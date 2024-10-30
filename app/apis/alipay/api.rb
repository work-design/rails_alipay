# frozen_string_literal: true

module Alipay
  module Api
    include CommonApi

    def execute(params, options = {})
      params = prepare_params(params, options)

      url = base_url
      Net::HTTP.post_form(url, params).body
    end

    def page_execute_url(params, options = {})
      params = prepare_page_params(params, options)

      url = base_url
      url.query = URI.encode_www_form(params)
      url.to_s
    end

    def sdk_execute(params, options = {})
      params = prepare_params(params, options)

      URI.encode_www_form(params)
    end

    def prepare_page_params(params, options = {})
      result = {
        return_url: params.fetch(:return_url, RailsAlipay.config.return_url),
        notify_url: params.fetch(:notify_url, RailsAlipay.config.notify_url)
      }
      result.compact!
      result.merge! common_params(options)
      result[:biz_content] = params.to_json if params.size >= 1
      result.merge! sign_params(result)
      result
    end

    def prepare_params(params, options = {})
      result = {}
      result.merge! common_params(options)
      result[:biz_content] = params.to_json if params.size >= 1
      result.merge! sign_params(result)
      result
    end

    def common_params(params)
      params[:app_id] ||= RailsAlipay.config.appid
      params.merge!(
        charset: 'utf-8',
        timestamp: Utils.timestamp,
        version: '1.0',
        format: 'JSON'  # optional
      )
    end

    def sign_params(params)
      params[:sign_type] ||= 'RSA2'
      params[:sign] = Sign.generate(params)
      params
    end
  end
end
