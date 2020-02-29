
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_record/find_only/version"

Gem::Specification.new do |spec|
  spec.name          = "activerecord-find_only"
  spec.version       = ActiveRecord::FindOnly::VERSION
  spec.authors       = ["Joshua Flanagan"]
  spec.email         = ["joshuaflanagan@gmail.com"]

  spec.summary       = %q{Query for a single item, and ensure it is the only one.}
  spec.description   = %q{Provides find_only and find_only! query methods}
  spec.homepage      = "https://github.com/joshuaflanagan/activerecord-find_only"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "sqlite3", "~> 1.3.6" # dictated by activerecord-5.2.2.1/lib/active_record/connection_adapters/sqlite3_adapter.rb:12
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
