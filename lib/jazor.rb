require 'json'
require 'logger'
require 'pp'

require 'rest_client'


module Jazor

  NAME = 'jazor'
  VERSION_INFO = ['0', '0', '2']
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
