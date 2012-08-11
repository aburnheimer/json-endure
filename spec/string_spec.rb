require File.expand_path File.join(File.dirname(__FILE__), '../lib/json-endure/string')

describe String, "#coax_into_json" do

  it "returns the string endured string" do
    string         = String.new('{ "123": "90", "abc": { "30')
    expected_value = String.new('{ "123": "90", "abc": { "30":""}}')

    test_value = string.coax_into_json

    test_value.should eq(expected_value)
  end
end

describe String, "#coax_into_json!" do

  it "coaxes the string back into proper JSON" do
    string         = String.new('{ "123": "90", "abc": { "30')
    expected_value = String.new('{ "123": "90", "abc": { "30":""}}')

    string.coax_into_json!

    expected_value.should eq(string)
  end
end

# vim:set et ts=2 sts=2 sw=2 tw=72 wm=72 ai:
