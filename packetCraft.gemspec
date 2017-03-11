# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'packetCraft/version'

Gem::Specification.new do |spec|
  spec.name          = "packetCraft"
  spec.version       = PacketCraft::VERSION
  spec.authors       = ["Apostolos D. Masiakos"]
  spec.email         = ["amasiakos@gmail.com"]
  spec.license       = "GPL-3.0"
  spec.summary       = "A tool to aid in packet creation for various purposes"
  spec.description   = <<-EOF
                       packetCraft is a tool to create various packets in need. The packets are
                       generated from .yml files.
                       EOF
  spec.homepage      = "https://github.com/mashua/packetCraft"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir.glob("**/**/**")
#  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
#    f.match(%r{^(test|spec|features)/})
#  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
