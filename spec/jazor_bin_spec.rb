require 'rspec'
require 'jazor'

describe 'Using jazor bin' do

  before(:all) do
    @init_url    = 'http://github.com/api/v2/json/commits/list/mconigliaro/jazor/master'
    @init_file   = File.expand_path(File.join(File.dirname(__FILE__), 'test.json'))
    @init_string = IO.read(@init_file)
    @jazor_bin   = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'jazor'))
  end

  it 'should print a help summary on absence of input' do
    `#{@jazor_bin}`.should =~ /Usage:/
  end

  it 'should parse JSON from STDIN' do
    JSON.parse(`cat #{@init_file} | #{@jazor_bin}`).should be_a(Hash)
  end

  it 'should parse JSON from a URL' do
    JSON.parse(`#{@jazor_bin} '#{@init_url}'`).should be_a(Hash)
  end

  it 'should parse JSON from a file' do
    JSON.parse(`#{@jazor_bin} #{@init_file}`).should be_a(Hash)
  end

  it 'should parse JSON from ARGV' do
    JSON.parse(`#{@jazor_bin} '#{@init_string}'`).should be_a(Hash)
  end

  it 'should parse JSON from a file with an expression' do
    eval(`#{@jazor_bin} #{@init_file} value1`).should be_a(Integer)
    JSON.parse(`#{@jazor_bin} #{@init_file} nested_object`).should be_a(Hash)
    JSON.parse(`#{@jazor_bin} #{@init_file} nested_object.array_of_values`).should be_a(Array)
    eval(`#{@jazor_bin} #{@init_file} dontexist`).should be_nil
  end

  it 'should parse JSON from a file with tests' do
    `#{@jazor_bin} -t #{@init_file} 'value1==123'`.should =~ /passed/
    `#{@jazor_bin} -t #{@init_file} 'value1==1234'`.should =~ /failed/
  end

  it 'should sort JSON' do
    if Jazor::HAS_ORDERED_HASH
      {
        '[3, 2, 1]'          => [1, 2, 3],
        '["foo", "bar", 1]'  => [1, 'bar', 'foo'],
        '{"foo":1, "bar":2}' => {'bar' => 2, 'foo' => 1},
        '{"1":1, "bar":2}'   => {'1' => 1, 'bar' => 2}
      }.each do |k,v|
        JSON.parse(`#{@jazor_bin} -s '#{k}'`).should == v
      end
    end
  end

end
