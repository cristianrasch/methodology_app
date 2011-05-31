# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-informix}
  s.version = "0.7.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gerardo Santana Gomez Garrido"]
  s.date = %q{2010-02-02}
  s.description = %q{Ruby library for connecting to IBM Informix 7 and above}
  s.email = %q{gerardo.santana@gmail.com}
  s.extensions = ["ext/extconf.rb"]
  s.files = ["ext/extconf.rb"]
  s.homepage = %q{http://ruby-informix.rubyforge.org/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-informix}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Ruby library for IBM Informix}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
