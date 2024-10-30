module Alipay
  module Model::App
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :name, :string
      attribute :appid, :string
      attribute :private_rsa, :string

      encrypts :private_rsa

      belongs_to :organ, class_name: 'Org::Organ', optional: true
    end

    def api
      return @api if defined? @api
      @api = Api::Core.new(self)
    end

  end
end
