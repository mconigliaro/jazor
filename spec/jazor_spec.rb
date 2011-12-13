require 'rspec'
require 'jazor'

describe 'Using Jazor library' do

  before(:all) do
    @init_json = IO.read(File.expand_path(File.join(File.dirname(__FILE__), 'test.json')))
    @init_hash = JSON.parse(@init_json)
  end

  it 'root object should be a hash' do
    Jazor::parse(@init_json).should be_a(Hash)
    Jazor::parse(@init_json).should == @init_hash
  end

  it 'should have correct values' do
    Jazor::parse(@init_json).value0.should be_a(String)
    Jazor::parse(@init_json).value1.should be_a(Integer)
    Jazor::parse(@init_json).value2.should be_a(Float)
    (0..2).each do |i|
      Jazor::parse(@init_json).send("value#{i}").should == @init_hash["value#{i}"]
    end
  end

  it 'should correctly parse array of values' do
    Jazor::parse(@init_json).array_of_values.should be_a(Array)
    Jazor::parse(@init_json).array_of_values.should == @init_hash['array_of_values']
    (0...Jazor::parse(@init_json).array_of_values.length).each do |i|
      Jazor::parse(@init_json).array_of_values[i].should be_a(Integer)
      Jazor::parse(@init_json).array_of_values[i].should == @init_hash["array_of_values"][i]
    end
  end

  it 'should correctly parse array of arrays' do
    Jazor::parse(@init_json).array_of_arrays.should be_a(Array)
    (0...Jazor::parse(@init_json).array_of_arrays.length).each do |i|
      Jazor::parse(@init_json).array_of_arrays[i].should be_a(Array)
      Jazor::parse(@init_json).array_of_arrays[i].should == @init_hash['array_of_arrays'][i]
      (0...Jazor::parse(@init_json).array_of_arrays[i].length).each do |j|
        Jazor::parse(@init_json).array_of_arrays[i][j].should be_a(Integer)
        Jazor::parse(@init_json).array_of_arrays[i][j].should == @init_hash['array_of_arrays'][i][j]
      end
    end
  end

  it 'should correctly parse array of objects' do
    Jazor::parse(@init_json).array_of_arrays.should be_a(Array)
    (0...Jazor::parse(@init_json).array_of_arrays.length).each do |i|
      Jazor::parse(@init_json).array_of_arrays[i].should be_a(Array)
      Jazor::parse(@init_json).array_of_arrays[i].should == @init_hash['array_of_arrays'][i]
      (0...Jazor::parse(@init_json).array_of_arrays[i].length).each do |j|
        Jazor::parse(@init_json).array_of_arrays[i][j].should be_a(Integer)
        Jazor::parse(@init_json).array_of_arrays[i][j].should == @init_hash['array_of_arrays'][i][j]
      end
    end
  end

end

