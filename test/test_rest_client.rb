require 'test/unit'

class TestExecute < Test::Unit::TestCase

  def test_get
    require 'jazor'

    response = Jazor::RestClient.get('http://ajax.googleapis.com/ajax/services/search/web')
    assert response.code == '200'
    assert response.body =~ /"responseStatus": 400/
  end

  def test_get_with_query_string
    response = Jazor::RestClient.get('http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=jazor')
    assert response.code == '200'
    assert response.body =~ /"responseStatus": 200/
  end

end
