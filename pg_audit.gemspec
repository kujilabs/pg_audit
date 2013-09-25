# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pg_audit/version'

Gem::Specification.new do |spec|
  spec.name          = "pg_audit"
  spec.version       = PgAudit::VERSION
  spec.authors       = ["stellard"]
  spec.email         = ["scott.ellard@gmail.com"]
  spec.description   = %q{Audit functionality for Postgres database}
  spec.summary       = %q{Audit functionality for Postgres database}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "activerecord", "~> 4.0.0"
  spec.add_dependency "activesupport", "~> 4.0.0"  
end