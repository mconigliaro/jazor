require 'minitest/autorun'
require 'minitest/pride'

require "jazor"

describe "Jazor command" do

  before do
    @test_url    = "https://api.github.com/repos/mconigliaro/jazor/commits"
    @test_file   = File.expand_path(File.join(File.dirname(__FILE__), "test.json"))
    @test_hash   = JSON.parse(IO.read(@test_file))
    @jazor_bin   = File.expand_path(File.join(File.dirname(__FILE__), "..", "bin", "jazor"))
  end

  it "prints a help summary on absence of input" do
    assert_match /Usage:/, `#{@jazor_bin}`
  end

  it "parses JSON from STDIN" do
    assert_equal JSON.parse(`cat #{@test_file} | #{@jazor_bin} -q`), @test_hash
  end

  it "parses JSON from a URL" do
    assert_kind_of Array, JSON.parse(`#{@jazor_bin} "#{@test_url}"`)
  end

  it "parses JSON from a file" do
    assert_equal JSON.parse(`#{@jazor_bin} #{@test_file}`), @test_hash
  end

  it "parses JSON from ARGV" do
    assert_equal JSON.parse(`#{@jazor_bin} '#{IO.read(@test_file)}'`), @test_hash
  end

  it "parses true/false values in quirks mode" do
    [true, false].each do |obj|
      assert_equal eval(`#{@jazor_bin} -q "#{obj}"`), obj
    end
  end

  it "exits with non-zero status on invalid JSON" do
    `#{@jazor_bin} invalid`
    refute_equal $?, 0
  end

  it "parses JSON from a file with an expression" do
    assert_equal JSON.parse(`#{@jazor_bin} #{@test_file} test_Array`), @test_hash["test_Array"]
    assert_equal eval(`#{@jazor_bin} #{@test_file} test_String`).to_s, @test_hash["test_String"]
    %w{Integer Float TrueClass FalseClass}.each do |t|
      assert_equal eval(`#{@jazor_bin} #{@test_file} test_#{t}`), @test_hash["test_#{t}"]
    end
    assert_nil eval(`#{@jazor_bin} #{@test_file} dontexist`)
  end

  it "parses JSON from a file with tests" do
    assert_match /passed/, `#{@jazor_bin} -t #{@test_file} "test_Integer==123"`
    assert_match /failed/, `#{@jazor_bin} -t #{@test_file} "test_Integer==1234"`
  end

  it "sorts output" do
    if Jazor::HAS_ORDERED_HASH
      {
        "[3, 2, 1]"          => [1, 2, 3],
        '["foo", "bar", 1]'  => [1, "bar", "foo"],
        '{"foo":1, "bar":2}' => {"bar" => 2, "foo" => 1},
        '{"1":1, "bar":2}'   => {"1" => 1, "bar" => 2}
      }.each do |k,v|
        assert_equal JSON.parse(`#{@jazor_bin} -s '#{k}'`), v
      end
    end
  end

end
