# frozen_string_literal: true

require_relative 'lib/legion/extensions/uais/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-uais'
  spec.version       = Legion::Extensions::Uais::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['legionio@esity.info']

  spec.summary       = 'LegionIO extension for United AI Studio (UAIS) registration'
  spec.description   = 'UAIS agent registration client with mock adapter and soft-warn enforcement'
  spec.homepage      = 'https://github.com/LegionIO/lex-uais'
  spec.license       = 'Apache-2.0'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files         = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }
  spec.require_paths = ['lib']

  spec.add_dependency 'legion-json',      '>= 1.2'
  spec.add_dependency 'legion-logging',   '>= 0.3'
  spec.add_dependency 'legion-settings',  '>= 0.3'
end
