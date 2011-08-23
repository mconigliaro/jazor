require 'test/unit'

class TestExecute < Test::Unit::TestCase

  def setup
    require 'jazor'

    @init_json = IO.read(File.expand_path(File.join(File.dirname(__FILE__), 'test.json')))
    @init_hash = JSON.parse(@init_json)
  end

  def test_root_object
    assert Jazor::parse(@init_json).is_a?(Hash)
    assert Jazor::parse(@init_json) == @init_hash
  end

  def test_values
    assert Jazor::parse(@init_json).value0.is_a?(String)
    assert Jazor::parse(@init_json).value1.is_a?(Integer)
    assert Jazor::parse(@init_json).value2.is_a?(Float)
    (0..2).each do |i|
      assert Jazor::parse(@init_json).send("value#{i}") == @init_hash["value#{i}"]
    end
  end

  def test_array_of_values
    assert Jazor::parse(@init_json).array_of_values.is_a?(Array)
    assert Jazor::parse(@init_json).array_of_values == @init_hash['array_of_values']
    (0...Jazor::parse(@init_json).array_of_values.length).each do |i|
      assert Jazor::parse(@init_json).array_of_values[i].is_a?(Integer)
      assert Jazor::parse(@init_json).array_of_values[i] == @init_hash["array_of_values"][i]
    end
  end

  def test_array_of_arrays
    assert Jazor::parse(@init_json).array_of_arrays.is_a?(Array)
    (0...Jazor::parse(@init_json).array_of_arrays.length).each do |i|
      assert Jazor::parse(@init_json).array_of_arrays[i].is_a?(Array)
      assert Jazor::parse(@init_json).array_of_arrays[i] == @init_hash['array_of_arrays'][i]
      (0...Jazor::parse(@init_json).array_of_arrays[i].length).each do |j|
        assert Jazor::parse(@init_json).array_of_arrays[i][j].is_a?(Integer)
        assert Jazor::parse(@init_json).array_of_arrays[i][j] == @init_hash['array_of_arrays'][i][j]
      end
    end
  end

  def test_array_of_objects
    assert Jazor::parse(@init_json).array_of_objects.is_a?(Array)
    (0...Jazor::parse(@init_json).array_of_objects.length).each do |i|
      assert Jazor::parse(@init_json).array_of_objects[i].is_a?(Hash)
      assert Jazor::parse(@init_json).array_of_objects[i] == @init_hash['array_of_objects'][i]
      assert Jazor::parse(@init_json).array_of_objects[i].send("object#{i}").is_a?(Integer)
      assert Jazor::parse(@init_json).array_of_objects[i].send("object#{i}") == @init_hash['array_of_objects'][i]["object#{i}"]
    end
  end

end
