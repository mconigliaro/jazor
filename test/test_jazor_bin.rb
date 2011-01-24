require 'test/unit'

$:.push File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jazor'


class TestExecute < Test::Unit::TestCase

  def setup
    @init_url = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=jazor'
    @init_file = File.expand_path(File.join(File.dirname(__FILE__), 'test.json'))
    @init_string = IO.read(@init_file)
    @jazor_bin = File.expand_path(File.join(File.dirname(__FILE__), '..', 'bin', 'jazor'))
  end

  def test_without_paramaters
    assert eval(`#{@jazor_bin}`).nil?
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

  def test_bad_json
    assert `#{@jazor_bin} '{"a":}'` =~ /ERROR/
  end

  def test_json_from_file_with_slice
    assert eval(`#{@jazor_bin} #{@init_file} value1`).is_a?(Numeric)
    assert JSON.parse(`#{@jazor_bin} #{@init_file} nested_object`).is_a?(Hash)
    assert JSON.parse(`#{@jazor_bin} #{@init_file} nested_object.array_of_values`).is_a?(Array)
    assert eval(`#{@jazor_bin} #{@init_file} dontexist`).nil?
  end

  def test_json_from_file_with_tests
    assert `#{@jazor_bin} #{@init_file} -t 'value1==123'` =~ /passed/
    assert `#{@jazor_bin} #{@init_file} -t 'value1==1234'` =~ /failed/
  end

end
