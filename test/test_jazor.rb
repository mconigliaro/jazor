require 'test/unit'

$:.push File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jazor'


class TestExecute < Test::Unit::TestCase

  def setup()
    @init_url = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=jazor'
    @init_file = File.expand_path(File.join(File.dirname(__FILE__), 'test.json'))
    @init_string = IO.read(@init_file)
    @init_hash = JSON.parse(@init_string)
    @jazor = Jazor::Jazor.new(@init_hash)
  end

  def test_jazor_from_url()
    Jazor::Jazor.new(@init_url)
  end

  def test_jazor_from_file()
    Jazor::Jazor.new(@init_file)
  end

  def test_jazor_from_string()
    Jazor::Jazor.new(@init_string)
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
  end

  def test_array_of_arrays
    assert @jazor.json.array_of_arrays.is_a?(Array)
    assert @jazor.json.array_of_arrays[0].is_a?(Array)
    assert @jazor.json.array_of_arrays[0] == @init_hash['array_of_arrays'][0]
    assert @jazor.json.array_of_arrays[0][0].is_a?(Numeric)
    assert @jazor.json.array_of_arrays[0][0] == @init_hash['array_of_arrays'][0][0]
  end

  def test_array_of_objects
    assert @jazor.json.array_of_objects.is_a?(Array)
    assert @jazor.json.array_of_objects[0].is_a?(Hash)
    assert @jazor.json.array_of_objects[0] == @init_hash['array_of_objects'][0]

    (0..2).each do |i|
      assert @jazor.json.array_of_objects[i].send("object#{i}").is_a?(Numeric)
      assert @jazor.json.array_of_objects[i].send("object#{i}") == @init_hash['array_of_objects'][i]["object#{i}"]
    end
  end

  def test_get_slice()
    jazor = Jazor::Jazor.new(@init_hash)
    assert jazor.get_slice.is_a?(Hash)
    assert jazor.get_slice == @init_hash
    assert jazor.get_slice('nested_object') == @init_hash['nested_object']
  end

end
