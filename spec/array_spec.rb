require File.expand_path File.join(File.dirname(__FILE__), '../lib/array')

describe Array, "#last=" do
  it "sets the last element to a new value" do
    array = Array.new
    array = [ 1, 3, 5 ]
    array.last = 4
    array.last.should eq(4)
  end
end

# vim:set et ts=2 sts=2 sw=2 tw=72 wm=72 ai:

