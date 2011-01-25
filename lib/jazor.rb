require 'json'
require 'logger'
require 'net/http'
require 'pp'
require 'uri'


module Jazor

  NAME = 'jazor'
  VERSION_INFO = ['0', '0', '3']
  VERSION = VERSION_INFO.join('.')
  AUTHOR = 'Michael T. Conigliaro'
  AUTHOR_EMAIL = 'mike [at] conigliaro [dot] org'
  URL = 'http://github.com/mconigliaro/jazor'

  LOG = Logger.new(STDOUT)
  LOG.level = Logger::INFO

  class Jazor

    attr_reader :json

    def initialize(source=nil)
      @json = source.nil? ? nil : JSON.parse(source)
    end

    def get_slice(slice=nil)
      if slice.nil?
        @json
      elsif slice =~ /^json/
        instance_eval(slice)
      else
        @json.instance_eval(slice)
      end
    end

    def method_missing(name)
      get_slice(name.to_s)
    end

  end

  class RestClient

    def self.method_missing(method, uri, headers={}, data={})
      uri_parsed = URI.parse(uri)
      http = Net::HTTP.new(uri_parsed.host, port=uri_parsed.port)
      request_uri = uri_parsed.query ? uri_parsed.path + '?' +  uri_parsed.query: uri_parsed.path
      request = Net::HTTP.const_get(method.to_s.capitalize).new(request_uri)
      headers.each { |k,v| request.add_field(k, v) }
      request.set_form_data(data)

      LOG.debug('%s %s: uri=%s headers=%s data=%s' % [self, method.to_s.upcase, File.join(uri_parsed.host, request_uri), headers.to_json, data.to_json])
      response = http.request(request)
      LOG.debug('%s result: code=%d body=%s' % [self, response.code, response.body.gsub("\r", ' ').gsub("\n", ' ')])

      response
    end

  end

end

class Hash
  def method_missing(name, value=nil)
    str_name = name.to_s
    if self.has_key?(str_name)
      self[str_name]
    else
      nil
    end
  end
end
