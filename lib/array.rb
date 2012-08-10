class Array
  def last=(arg)
    self.pop
    self << arg
  end
end
