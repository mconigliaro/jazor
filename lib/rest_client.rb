require 'net/http'
require 'uri'

module Jazor

  class RestClient

    def self.method_missing(method, uri, headers={}, data={})
      uri = URI.parse(uri)
      http = Net::HTTP.new(uri.host, port=uri.port)
      request = Net::HTTP.const_get(method.to_s.capitalize).new(uri.path)
      headers.each { |k,v| request.add_field(k, v) }
      request.set_form_data(data)

      LOG.debug('%s %s: url=%s headers=%s data=%s' % [self, method.to_s.upcase, File.join(uri.host, uri.path), headers.to_json, data.to_json])
      response = http.request(request)
      LOG.debug('%s result: code=%d body="%s"' % [self, response.code, response.body.gsub("\r", ' ').gsub("\n", ' ')])

      response
    end

  end

end
