describe "Jazor command" do

  before(:all) do
    @test_url    = "http://github.com/api/v2/json/commits/list/mconigliaro/jazor/master"
    @test_file   = File.expand_path(File.join(File.dirname(__FILE__), "test.json"))
    @test_hash   = JSON.parse(IO.read(@test_file))
    @jazor_bin   = File.expand_path(File.join(File.dirname(__FILE__), "..", "bin", "jazor"))
  end

  it "prints a help summary on absence of input" do
    `#{@jazor_bin}`.should =~ /Usage:/
  end

  it "parses JSON from STDIN" do
    JSON.parse(`cat #{@test_file} | #{@jazor_bin} -q`).should == @test_hash
  end

  it "parses JSON from a URL" do
    JSON.parse(`#{@jazor_bin} "#{@test_url}"`).should be_a Hash
  end

  it "parses JSON from a file" do
    JSON.parse(`#{@jazor_bin} #{@test_file}`).should == @test_hash
  end

  it "parses JSON from ARGV" do
    JSON.parse(`#{@jazor_bin} '#{IO.read(@test_file)}'`).should == @test_hash
  end

  it "parses true/false values in quirks mode" do
    [true, false].each do |obj|
      eval(`#{@jazor_bin} -q "#{obj}"`).should == obj
    end
  end

  it "exits with non-zero status on invalid JSON" do
    `#{@jazor_bin} invalid`
    $?.should_not == 0
  end

  it "parses JSON from a file with an expression" do
    JSON.parse(`#{@jazor_bin} #{@test_file} test_Array`).should == @test_hash["test_Array"]
    eval(`#{@jazor_bin} #{@test_file} test_String`).to_s.should == @test_hash["test_String"]
    %w{Integer Float TrueClass FalseClass}.each do |t|
      eval(`#{@jazor_bin} #{@test_file} test_#{t}`).should == @test_hash["test_#{t}"]
    end
    eval(`#{@jazor_bin} #{@test_file} dontexist`).should be_nil
  end

  it "parses JSON from a file with tests" do
    `#{@jazor_bin} -t #{@test_file} "test_Integer==123"`.should =~ /passed/
    `#{@jazor_bin} -t #{@test_file} "test_Integer==1234"`.should =~ /failed/
  end

  it "sorts output" do
    if Jazor::HAS_ORDERED_HASH
      {
        "[3, 2, 1]"          => [1, 2, 3],
        '["foo", "bar", 1]'  => [1, "bar", "foo"],
        '{"foo":1, "bar":2}' => {"bar" => 2, "foo" => 1},
        '{"1":1, "bar":2}'   => {"1" => 1, "bar" => 2}
      }.each do |k,v|
        JSON.parse(`#{@jazor_bin} -s '#{k}'`).should == v
      end
    end
  end

end
