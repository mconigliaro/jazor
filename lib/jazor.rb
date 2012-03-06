require "rubygems"
require "bundler/setup"

require "json"
require "logger"
require "net/http"
require "net/https"
require "pp"
require "uri"

module Jazor

  NAME         = "jazor"
  VERSION      = "0.1.4"
  AUTHOR       = "Michael Paul Thomas Conigliaro"
  AUTHOR_EMAIL = "mike [at] conigliaro [dot] org"
  DESCRIPTION  = "Jazor (JSON razor) is a simple command line JSON parsing tool."
  URL          = "http://github.com/mconigliaro/jazor"

  LOG = Logger.new(STDOUT)
  LOG.level = Logger::INFO

  HAS_ORDERED_HASH = (RUBY_VERSION.split(".").map(&:to_i) <=> [1, 9, 1]) >= 0

  def self.parse(input=nil, options={})
    obj = JSON.parse(input, options)
    Jazor::LOG.debug("Parsed JSON as a #{obj.class}")
    obj
  end

  def self.evaluate(obj, expression)
    result = expression.nil? ? obj : obj.instance_eval(expression)
    Jazor::LOG.debug("Expression (#{expression}) returns a #{result.class}")
    result
  end

  class RestClient
    def self.method_missing(method, uri, headers={}, data={})
      uri_parsed = URI.parse(uri)
      http = Net::HTTP.new(uri_parsed.host, port=uri_parsed.port)
      if uri_parsed.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
      request_uri = uri_parsed.query ? "#{uri_parsed.path}?#{uri_parsed.query}" : uri_parsed.path
      request = Net::HTTP.const_get(method.to_s.capitalize).new(request_uri)
      headers.each { |k,v| request.add_field(k, v) }
      request.set_form_data(data)

      LOG.debug("#{self} #{method.to_s.upcase}: uri=#{File.join(uri_parsed.host, request_uri)} headers=#{headers.to_json} data=#{data.to_json}")
      response = http.request(request)
      LOG.debug("#{self} result: code=#{response.code} body=%s" % response.body.gsub("\r", " ").gsub("\n", " "))

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
