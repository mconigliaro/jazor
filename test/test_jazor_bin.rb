require 'test/unit'

class TestExecute < Test::Unit::TestCase

  def setup
    require 'jazor'

    @init_url    = 'http://github.com/api/v2/json/commits/list/mconigliaro/jazor/master'
    @init_file   = File.expand_path(File.join(File.dirname(__FILE__), 'test.json'))
    @init_string = IO.read(@init_file)
    @jazor_bin   = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'jazor'))
  end

  def test_without_paramaters
    assert `#{@jazor_bin}` =~ /Usage:/
  end

  def test_json_from_stdin
    assert JSON.parse(`cat #{@init_file} | #{@jazor_bin}`).is_a?(Hash)
  end

  def test_json_from_url
    assert JSON.parse(`#{@jazor_bin} '#{@init_url}'`).is_a?(Hash)
  end

  def test_json_from_file
    assert JSON.parse(`#{@jazor_bin} #{@init_file}`).is_a?(Hash)
  end

  def test_json_from_argv
    assert JSON.parse(`#{@jazor_bin} '#{@init_string}'`).is_a?(Hash)
  end

  def test_json_from_file_with_expression
    assert eval(`#{@jazor_bin} #{@init_file} value1`).is_a?(Integer)
    assert JSON.parse(`#{@jazor_bin} #{@init_file} nested_object`).is_a?(Hash)
    assert JSON.parse(`#{@jazor_bin} #{@init_file} nested_object.array_of_values`).is_a?(Array)
    assert eval(`#{@jazor_bin} #{@init_file} dontexist`).nil?
  end

  def test_json_from_file_with_tests
    assert `#{@jazor_bin} -t #{@init_file} 'value1==123'` =~ /passed/
    assert `#{@jazor_bin} -t #{@init_file} 'value1==1234'` =~ /failed/
  end

  def test_sorting
    if Jazor::HAS_ORDERED_HASH
      {
        '[3, 2, 1]'          => [1, 2, 3],
        '["foo", "bar", 1]'  => [1, 'bar', 'foo'],
        '{"foo":1, "bar":2}' => {'bar' => 2, 'foo' => 1},
        '{"1":1, "bar":2}'   => {'1' => 1, 'bar' => 2}
      }.each do |k,v|
        assert JSON.parse(`#{@jazor_bin} -s '#{k}'`) == v
      end
    end
  end

end
