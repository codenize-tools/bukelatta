# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bukelatta/version'

Gem::Specification.new do |spec|
  spec.name          = 'bukelatta'
  spec.version       = Bukelatta::VERSION
  spec.authors       = ['winebarrel']
  spec.email         = ['sgwr_dts@yahoo.co.jp']

  spec.summary       = %q{Bukelatta is a tool to manage S3 Bucket Policy.}
  spec.description   = %q{Bukelatta is a tool to manage S3 Bucket Policy.}
  spec.homepage      = 'git@github.com:winebarrel/bukelatta.git'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk', '~> 2.3.0'
  spec.add_dependency 'diffy'
  spec.add_dependency 'hashie'
  spec.add_dependency 'multi_xml'
  spec.add_dependency 'parallel'
  spec.add_dependency 'term-ansicolor'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
