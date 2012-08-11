require File.expand_path File.join(File.dirname(__FILE__), 'json')

class String

  def coax_into_json()
    str = self.clone
    str.coax_into_json!()
    return str
  end

  def coax_into_json!()
    self.replace(JSON.endure(self))
  end

end

# vim:set et ts=2 sts=2 sw=2 tw=72 wm=72 ai:
