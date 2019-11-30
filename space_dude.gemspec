# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'space_dude/version'

Gem::Specification.new do |spec|
  spec.name = "space_dude"
  spec.version = SpaceDude::VERSION
  spec.authors = ["Ivan Gonzalez"]
  spec.email = ["ivan@simplelogica.net"]

  spec.summary = "Simplelogica: The Game. A game developed in Ruby."
  spec.description = "Simplelogica: The Game. A game developed in Ruby with the help of Gosu gem."
  spec.homepage = "https://github.com/dreamingechoes/space_dude"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gosu", ">= 0.9.0"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
