require File.expand_path File.join(File.dirname(__FILE__), 'json')

class String

  def survive_json()
    str = self.clone
    str.survive_json!()
    return str
  end

  def survive_json!()
    self = JSON.endure(self)
  end

end

# vim:set et ts=2 sts=2 sw=2 tw=72 wm=72 ai:
