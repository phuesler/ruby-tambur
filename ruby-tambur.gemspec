# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ruby-tambur/version"

Gem::Specification.new do |s|
  s.name        = "ruby-tambur"
  s.version     = Ruby::Tambur::VERSION
  s.authors     = ["Andre Graf"]
  s.email       = ["graf@tambur.io"]
  s.homepage    = "https://github.com/tamburio/ruby-tambur"
  s.summary     = %q{Simple Client for the Tambur.io REST API}
  s.description = %q{Simple Client for the Tambur.io REST API}

  s.rubyforge_project = "ruby-tambur"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_runtime_dependency "json"
end
