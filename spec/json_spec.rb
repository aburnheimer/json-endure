$:.delete(File.expand_path File.join(File.dirname(__FILE__), '../lib'))
require 'json'
require File.expand_path File.join(File.dirname(__FILE__), '../lib/json-endure/json')

describe JSON, "::endure" do

  it "returns the endured string" do
    string         = String.new('{ "123": "90", "abc": { "30')
    expected_value = String.new('{ "123": "90", "abc": { "30":""}}')

    test_value = JSON.endure(string)

    test_value.should eq(expected_value)
  end
end

describe JSON, "::endure_and_parse" do

  it "handles empty arrays" do
    string = String.new('[]')
    expected_value = Array.new

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles empty hashes" do
    string = String.new('{}')
    expected_value = Hash.new

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  # ----- IN_ARRAY -----

  it "handles an array with a single value" do
    string = String.new('[ 123 ]')
    expected_value = Array.new
    expected_value << 123

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles empty hashes inside an array" do
    string = String.new('[1, {}]')
    expected_value = Array.new
    expected_value << 1
    expected_value << Hash.new

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles empty arrays inside a hash" do
    string = String.new('{"a": []}')
    expected_value = Hash.new
    expected_value["a"] = Array.new

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted array, pre-value" do
    string = String.new('[ ')
    expected_value = Array.new
    expected_value << ""

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted array mid-value" do
    string = String.new('[ 123, 90')
    expected_value = Array.new
    expected_value << 123
    expected_value << 90

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted array mid-string" do
    string = String.new('[ 123, "90')
    expected_value = Array.new
    expected_value << 123
    expected_value << "90"

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles embedded literal \" characters mid-string" do
    string = String.new('[ 123, "9\"0')
    expected_value = Array.new
    expected_value << 123
    expected_value << '9"0'

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted array inside an array" do
    string = String.new('[ 123, [ 30')
    expected_value = Array.new
    expected_value << 123
    internal_array = Array.new
    internal_array << 30
    expected_value << internal_array

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted array with a complete internal array" do
    string = String.new('[ 123, [ 30 ]')
    expected_value = Array.new
    expected_value << 123
    internal_array = Array.new
    internal_array << 30
    expected_value << internal_array

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted array, mid-key, inside an array" do
    string = String.new('[ 123, { "90')
    expected_value = Array.new
    expected_value << 123
    internal_hash = Hash.new
    internal_hash["90"] = ""
    expected_value << internal_hash

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted array, mid-value, inside an array" do
    string = String.new('[ 123, { "90": 123')
    expected_value = Array.new
    expected_value << 123
    internal_hash = Hash.new
    internal_hash["90"] = 123
    expected_value << internal_hash

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted array, mid-string, inside an array" do
    string = String.new('[ 123, { "90": "123')
    expected_value = Array.new
    expected_value << 123
    internal_hash = Hash.new
    internal_hash["90"] = "123"
    expected_value << internal_hash

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted array with a complete internal hash" do
    string = String.new('[ 123, { "90": "123" }' )
    expected_value = Array.new
    expected_value << 123
    internal_hash = Hash.new
    internal_hash["90"] = "123"
    expected_value << internal_hash

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted array after string" do
    string = String.new('[ 123, "90"')
    expected_value = Array.new
    expected_value << 123
    expected_value << "90"

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  # ----- IN_HASH -----

  it "handles an array with a single value" do
    string = String.new('{ "123": 90')
    expected_value = Hash.new
    expected_value["123"] = 90

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted hash, pre-key" do
    string = String.new('{ ')
    expected_value = Hash.new
    expected_value[""] = ""

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted hash, mid-key" do
    string = String.new('{ "12')
    expected_value = Hash.new
    expected_value["12"] = ""

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted hash, post-key" do
    string = String.new('{ "12": ')
    expected_value = Hash.new
    expected_value["12"] = ""

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted hash, mid-value" do
    string = String.new('{ "123": 90')
    expected_value = Hash.new
    expected_value["123"] = 90

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted hash, mid-string" do
    string = String.new('{ "123": "90')
    expected_value = Hash.new
    expected_value["123"] = "90"

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles embedded literal \" characters mid-string" do
    string = String.new('{ "123": "9\"0')
    expected_value = Hash.new
    expected_value["123"] = '9"0'

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end


  it "handles interrupted hash after string" do
    string = String.new('{ "123": "90"')
    expected_value = Hash.new
    expected_value["123"] = "90"

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted hash with an interrupted internal array" do
    string = String.new('{ "123": "90", "abc": [ 30')
    expected_value = Hash.new
    expected_value["123"] = "90"
    internal_array = Array.new
    internal_array << 30
    expected_value["abc"] = internal_array

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted hash with a complete internal array" do
    string = String.new('{ "123": "90", "abc": [ 30 ]')
    expected_value = Hash.new
    expected_value["123"] = "90"
    internal_array = Array.new
    internal_array << 30
    expected_value["abc"] = internal_array

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted hash, mid-key, inside a hash" do
    string = String.new('{ "123": "90", "abc": { "30')
    expected_value = Hash.new
    expected_value["123"] = "90"
    internal_array = Hash.new
    internal_array["30"] = ""
    expected_value["abc"] = internal_array

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted hash, mid-value, inside a hash" do
    string = String.new('{ "123": "90", "abc": { "30": 456')
    expected_value = Hash.new
    expected_value["123"] = "90"
    internal_array = Hash.new
    internal_array["30"] = 456
    expected_value["abc"] = internal_array

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted hash, mid-string, inside a hash" do
    string = String.new('{ "123": "90", "abc": { "30": "456')
    expected_value = Hash.new
    expected_value["123"] = "90"
    internal_array = Hash.new
    internal_array["30"] = "456"
    expected_value["abc"] = internal_array

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles an interrupted hash with a complete internal hash" do
    string = String.new('{ "123": "90", "abc": { "30": "456" }')
    expected_value = Hash.new
    expected_value["123"] = "90"
    internal_array = Hash.new
    internal_array["30"] = "456"
    expected_value["abc"] = internal_array

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

  it "handles interrupted hash, after pair, pre-key" do
    string = String.new('{ "123": "90", ')
    expected_value = Hash.new
    expected_value["123"] = "90"
    expected_value[""] = ""

    test_value = JSON.endure_and_parse(string)

    test_value.should eq(expected_value)
  end

end

# vim:set et ts=2 sts=2 sw=2 tw=72 wm=72 ai:
