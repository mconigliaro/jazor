require 'logger'
require 'net/http'
require 'pp'
require 'uri'

require 'rubygems'
require 'json'


module Jazor

  NAME         = 'jazor'
  VERSION      = '0.1.0'
  AUTHOR       = 'Michael T. Conigliaro'
  AUTHOR_EMAIL = 'mike [at] conigliaro [dot] org'
  DESCRIPTION  = 'Jazor is a simple command line JSON parsing tool'
  URL          = 'http://github.com/mconigliaro/jazor'

  LOG = Logger.new(STDOUT)
  LOG.level = Logger::INFO

  def self.parse(input=nil)
    # FIXME: https://github.com/flori/json/issues/16
    obj = (JSON.parse(input) rescue false) || (Integer(input) rescue false) || (Float(input) rescue false) || String(input)
    if obj.is_a?(String)
      if obj == 'true'
        obj = true
      elsif obj == 'false'
        obj = false
      end
    end
    obj
  end

  class RestClient
    def self.method_missing(method, uri, headers={}, data={})
      uri_parsed = URI.parse(uri)
      http = Net::HTTP.new(uri_parsed.host, port=uri_parsed.port)
      request_uri = uri_parsed.query ? "#{uri_parsed.path}?#{uri_parsed.query}" : uri_parsed.path
      request = Net::HTTP.const_get(method.to_s.capitalize).new(request_uri)
      headers.each { |k,v| request.add_field(k, v) }
      request.set_form_data(data)

      LOG.debug("#{self} #{method.to_s.upcase}: uri=#{File.join(uri_parsed.host, request_uri)} headers=#{headers.to_json} data=#{data.to_json}")
      response = http.request(request)
      LOG.debug("#{self} result: code=#{response.code} body=%s" % response.body.gsub("\r", ' ').gsub("\n", ' '))

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
