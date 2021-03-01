lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'petfinder_V2/version'

Gem::Specification.new do |spec|
  spec.name          = 'petfinder_V2'
  spec.version       = PetfinderV2::VERSION
  spec.authors       = ['Ben Wanicur']
  spec.email         = ['bwanicur@gmail.com']

  spec.homepage      = 'https://github.com/bwanicur/petfinder_v2'
  spec.summary       = ' Wrapper for the Petfinder V2 API '
  spec.description   = ' Wrapper for the Petfinder V2 API '
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'json'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
