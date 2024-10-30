require 'net/http'
require 'cgi'

require 'alipay2/config'
require 'alipay2/utils'
require 'alipay2/sign'
require 'alipay2/service'
require 'alipay2/notify'

module Alipay2
  attr_accessor :root
  extend self

end
