Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'json-endure'
  s.version     = '0.1.1'
  s.summary     = %q{Handle truncated JSON-text}

  s.description = %q{Helper methods to JSON and String to make-do } +
    %q{with truncated JSON text.}

  s.license     = 'CC-BY-3.0'

  s.author      = 'Andrew Burnheimer'
  s.email       = 'Andrew_Burnheimer@cable.comcast.com'
  s.homepage    = 'https://github.com/aburnheimer/json-endure'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  # specify any dependencies here:
  s.add_dependency("json")
end
