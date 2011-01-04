require 'json'
require 'net/http'
require 'pp'
require 'uri'


module Jazor

  class JObject

    def initialize(hash={})
      hash.each do |k,v|
        k = k.gsub('.', '_')
        if v.is_a?(Hash)
          instance_variable_set("@#{k}", JObject.new(v))
        else
          instance_variable_set("@#{k}", v)
        end
      end
    end

    def to_hash()
      hash = {}
      instance_variables.each do |name|
        hname = name.sub('@', '')
        value = instance_variable_get(name)
        if value.is_a?(JObject)
          hash[hname] = value.to_hash()
        else
          hash[hname] = value
        end
      end
      return hash
    end

    def method_missing(name, value=nil)
      if name.to_s =~ /=$/
        instance_variable_set("@#{name.chop}", value)
      else
        instance_variable_get("@#{name}")
      end
    end

  end

  class Jazor

    attr_reader :data

    def initialize(source)
      hash = nil
      if !source.nil?
        if source.is_a?(Hash)
          hash = source
        elsif source =~ URI::regexp
          hash = JSON.parse(Net::HTTP.get(URI.parse(source)))
        elsif File.readable?(source)
          hash = JSON.parse(IO.read(source))
        else
          hash = JSON.parse(source)
        end
      end
      @data = JObject.new(hash)
    end

    def get_slice(slice=nil)
      if !slice.nil?
        @data.instance_eval(slice)
      else
        @data
      end
    end

  end

end
