require 'rspec'
require 'jazor'

describe 'Using REST client' do

  it 'GET should work over HTTP' do
    response = Jazor::RestClient.get('http://ajax.googleapis.com/ajax/services/search/web')
    response.code.should == '200'
    response.body.should =~ /"responseStatus": 400/
  end

  it 'GET should work over HTTPS' do
    response = Jazor::RestClient.get('https://github.com/api/v2/json/commits/list/mconigliaro/jazor/master')
    response.code.should == '200'
  end

  it 'GET should work over HTTP with query string' do
    response = Jazor::RestClient.get('http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=jazor')
    response.code.should == '200'
    response.body.should =~ /"responseStatus": 200/
  end

end
