require 'test/unit'

$:.push File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jazor'


class TestExecute < Test::Unit::TestCase

  def setup
    @init_json = IO.read(File.expand_path(File.join(File.dirname(__FILE__), 'test.json')))
    @init_hash = JSON.parse(@init_json)
    @jazor = Jazor::Jazor.new(@init_json)
  end

  def test_init
    Jazor::Jazor.new(@init_json)
  end

  def test_root_object
    assert @jazor.json.is_a?(Hash)
    assert @jazor.json == @init_hash
  end

  def test_values
    assert @jazor.json.value0.is_a?(String)
    assert @jazor.json.value1.is_a?(Integer)
    assert @jazor.json.value2.is_a?(Float)
    (0..2).each do |i|
      assert @jazor.json.send("value#{i}") == @init_hash["value#{i}"]
    end
  end

  def test_array_of_values
    assert @jazor.json.array_of_values.is_a?(Array)
    assert @jazor.json.array_of_values == @init_hash['array_of_values']
    (0...@jazor.json.array_of_values.length).each do |i|
      assert @jazor.json.array_of_values[i].is_a?(Integer)
      assert @jazor.json.array_of_values[i] == @init_hash["array_of_values"][i]
    end
  end

  def test_array_of_arrays
    assert @jazor.json.array_of_arrays.is_a?(Array)
    (0...@jazor.json.array_of_arrays.length).each do |i|
      assert @jazor.json.array_of_arrays[i].is_a?(Array)
      assert @jazor.json.array_of_arrays[i] == @init_hash['array_of_arrays'][i]
      (0...@jazor.json.array_of_arrays[i].length).each do |j|
        assert @jazor.json.array_of_arrays[i][j].is_a?(Integer)
        assert @jazor.json.array_of_arrays[i][j] == @init_hash['array_of_arrays'][i][j]
      end
    end
  end

  def test_array_of_objects
    assert @jazor.json.array_of_objects.is_a?(Array)
    (0...@jazor.json.array_of_objects.length).each do |i|
      assert @jazor.json.array_of_objects[i].is_a?(Hash)
      assert @jazor.json.array_of_objects[i] == @init_hash['array_of_objects'][i]
      assert @jazor.json.array_of_objects[i].send("object#{i}").is_a?(Integer)
      assert @jazor.json.array_of_objects[i].send("object#{i}") == @init_hash['array_of_objects'][i]["object#{i}"]
    end
  end

  def test_get_nil_slice_returns_complete_object()
    assert @jazor.get_slice.is_a?(Hash)
    assert @jazor.get_slice == @init_hash
  end

  def test_get_slice()
    assert @jazor.get_slice('nested_object') == @init_hash['nested_object']
  end

end
