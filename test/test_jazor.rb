require 'test/unit'

$:.push File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jazor'


class TestExecute < Test::Unit::TestCase

  def setup()
    @init_url = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=jazor'
    @init_file = File.expand_path(File.join(File.dirname(__FILE__), 'test.json'))
    @init_string = IO.read(@init_file)
    @init_hash = JSON.parse(@init_string)
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

  def test_jazor_from_hash()
    Jazor::Jazor.new(@init_hash)
  end

  def test_get_slice()
    jazor = Jazor::Jazor.new(@init_hash)
    assert jazor.get_slice.is_a?(Jazor::JObject)
    assert jazor.get_slice.to_hash == @init_hash
    assert jazor.get_slice('object').to_hash == @init_hash['object']
  end

end
