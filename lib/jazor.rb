require 'json'
require 'net/http'
require 'pp'
require 'uri'


module Jazor

  NAME = 'jazor'
  VERSION_INFO = ['0', '0', '1']
  VERSION = VERSION_INFO.join('.')
  AUTHOR = 'Michael T. Conigliaro'
  AUTHOR_EMAIL = 'mike [at] conigliaro [dot] org'
  URL = 'http://github.com/mconigliaro/jazor'

  class Jazor

    attr_reader :json

    def initialize(source)
      @json = nil
      if !source.nil?
        if source.is_a?(Hash)
          @json = source
        elsif source =~ URI::regexp
          @json = JSON.parse(Net::HTTP.get(URI.parse(source)))
        elsif File.readable?(source)
          @json = JSON.parse(IO.read(source))
        else
          @json = JSON.parse(source)
        end
      end
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
