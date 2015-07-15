# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paperclip_storage_filesystem_versioned/version'

Gem::Specification.new do |spec|
  spec.name          = "paperclip_storage_filesystem_versioned"
  spec.version       = PaperclipStorageFilesystemVersioned::VERSION
  spec.authors       = ["Mariusz Michalak"]
  spec.email         = ["stricte@gmail.com"]
  spec.summary       = %q{Versioned version of filesystem storage.}
  spec.description   = %q{Versioned version of filesystem storage.}
  spec.homepage      = "http://softica.pl"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
