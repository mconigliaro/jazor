require 'json'

require 'test/unit'

$:.push File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jazor'


class TestExecute < Test::Unit::TestCase

  def setup()
    @init_hash = JSON.parse(IO.read(File.expand_path(File.join(File.dirname(__FILE__), 'test.json'))))
    @j_object = Jazor::JObject.new(@init_hash)
  end

  def test_root_object
    assert @j_object.is_a?(Jazor::JObject)
    assert @j_object.to_hash == @init_hash
  end

  def test_level_1_string
    assert @j_object.string.is_a?(String)
    assert @j_object.string == @init_hash['string']
  end

  def test_level_1_int
    assert @j_object.int.is_a?(Integer)
    assert @j_object.int == @init_hash['int']
  end

  def test_level_1_float
    assert @j_object.float.is_a?(Float)
    assert @j_object.float == @init_hash['float']
  end

  def test_level_1_array
    assert @j_object.array.is_a?(Array)
    assert @j_object.array == @init_hash['array']
  end

  def test_level_1_object
    assert @j_object.object.is_a?(Jazor::JObject)
    assert @j_object.object.to_hash == @init_hash['object']
  end

  def test_level_2_string
    assert @j_object.object.string.is_a?(String)
    assert @j_object.object.string == @init_hash['object']['string']
  end

  def test_level_2_int
    assert @j_object.object.int.is_a?(Integer)
    assert @j_object.object.int == @init_hash['object']['int']
  end

  def test_level_2_float
    assert @j_object.object.float.is_a?(Float)
    assert @j_object.object.float == @init_hash['object']['float']
  end

  def test_level_2_array
    assert @j_object.object.array.is_a?(Array)
    assert @j_object.object.array == @init_hash['object']['array']
  end

  def test_level_2_object
    assert @j_object.object.object.is_a?(Jazor::JObject)
    assert @j_object.object.object.to_hash == @init_hash['object']['object']
  end

end
