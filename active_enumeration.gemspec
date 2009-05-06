# -*- encoding: utf-8 -*-
require 'rake'

Gem::Specification.new do |s|
  s.name = %q{active_enumeration}
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glenn Powell"]
  s.date = %q{2009-05-03}
  s.description = %q{Allows for the creation of Active-Record-esque "enum" classes, which can be referenced by a String value.}
  s.email = %q{glennpow@gmail.com}
  s.files = FileList['lib/**/*.rb', '[A-Z]*', 'test/**/*'].to_a
  s.has_rdoc = true
  s.homepage = %q{http://github.com/glennpow/active_enumeration}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Allows for the creation of Active-Record-esque "enum" classes, which can be referenced by a String value.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 1.15"])
      s.add_runtime_dependency(%q<diff-lcs>, [">= 1.1.2"])
    else
      s.add_dependency(%q<mime-types>, [">= 1.15"])
      s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 1.15"])
    s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
  end
end
