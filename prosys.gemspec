$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'prosys/version'

Gem::Specification.new 'prosys', Prosys::VERSION do |s|
  s.summary           = "A Ruby client for ProVu's ProSys XML API"
  s.description       = "ProSys XML-based API."
  s.author            = 'Ben Thompson'
  s.email             = "ben@atechmedia.com"
  s.homepage          = "http://secure.provu.co.uk/"
  s.files             = `git ls-files`.split("\n") - %w[.gitignore]
  s.test_files        = s.files.select { |p| p =~ /^test\/.*_test.rb/ }
  s.extra_rdoc_files  = s.files.select { |p| p =~ /^README/ } << 'LICENSE'
  s.rdoc_options      = %w[--line-numbers --inline-source --title ProSys --main README.rdoc]

  s.add_dependency 'activesupport'
  s.add_dependency 'crack'
  s.add_dependency 'builder'
  s.add_dependency 'mechanize'
  s.add_dependency 'pry'
end
