describe "Jazor lib" do

  before(:all) do
    @test_file = IO.read(File.expand_path(File.join(File.dirname(__FILE__), "test.json")))
    @test_hash = JSON.parse(@test_file)
  end

  %w{String Integer Float TrueClass FalseClass NilClass Array}.each do |t|
    it "parses #{t} values in the root object" do
      obj = Jazor::parse(@test_file)["test_#{t}"]
      obj.should be_a Kernel.const_get(t)
      obj.should == @test_hash["test_#{t}"]
    end

    it "evaluates the expression \"test_#{t}\" and returns the correct result" do
      obj = Jazor::evaluate(Jazor::parse(@test_file), "test_#{t}")
      obj.should be_a Kernel.const_get(t)
      obj.should == @test_hash["test_#{t}"]
    end
  end

  describe "REST client" do

    it "can issue GET requests over HTTP" do
      response = Jazor::RestClient.get("http://ajax.googleapis.com/ajax/services/search/web")
      response.code.should == "200"
      response.body.should =~ /"responseStatus": 400/
    end

    it "can issue GET requests over HTTPS" do
      response = Jazor::RestClient.get("https://github.com/api/v2/json/commits/list/mconigliaro/jazor/master")
      response.code.should == "200"
    end

    it "can issue GET requests over HTTP with a query string" do
      response = Jazor::RestClient.get("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=jazor")
      response.code.should == "200"
      response.body.should =~ /"responseStatus": 200/
    end

  end

end

