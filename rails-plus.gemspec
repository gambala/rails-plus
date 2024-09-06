lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-plus/version'

Gem::Specification.new do |s|
  s.name     = 'rails-plus'
  s.version  = RailsPlus::VERSION
  s.authors  = ['Vitaliy Emeliyantsev']
  s.email    = 'gambala.rus@gmail.com'
  s.summary  = 'Cozy helpers for Ruby on Rails'
  s.homepage = 'https://github.com/gambala/rails-plus'
  s.license  = 'MIT'
  s.files    = `git ls-files`.split("\n")
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sprockets'
end
