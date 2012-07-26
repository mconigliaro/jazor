require 'minitest/autorun'
require 'minitest/pride'

require "jazor"

describe "Jazor lib" do

  before do
    @test_file = IO.read(File.expand_path(File.join(File.dirname(__FILE__), "test.json")))
    @test_hash = JSON.parse(@test_file)
  end

  %w{String Integer Float TrueClass FalseClass NilClass Array}.each do |t|
    it "parses #{t} values in the root object" do
      obj = Jazor::parse(@test_file)["test_#{t}"]
      assert_kind_of Kernel.const_get(t), obj
      assert_equal obj, @test_hash["test_#{t}"]
    end

    it "evaluates the expression \"test_#{t}\" and returns the correct result" do
      obj = Jazor::evaluate(Jazor::parse(@test_file), "test_#{t}")
      assert_kind_of Kernel.const_get(t), obj
      assert_equal obj, @test_hash["test_#{t}"]
    end
  end

  describe "REST client" do

    it "can issue GET requests over HTTP" do
      response = Jazor::RestClient.get("http://ajax.googleapis.com/ajax/services/search/web")
      assert_equal response.code, "200"
      assert_match /"responseStatus": 400/, response.body
    end

    it "can issue GET requests over HTTPS" do
      response = Jazor::RestClient.get("https://api.github.com/repos/mconigliaro/jazor/commits")
      assert_equal response.code, "200"
    end

    it "can issue GET requests over HTTP with a query string" do
      response = Jazor::RestClient.get("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=jazor")
      assert_equal response.code, "200"
      assert_match /"responseStatus": 200/, response.body
    end

  end

end
