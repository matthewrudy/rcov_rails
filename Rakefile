require "rubygems"
require "rubygems/package_task"

task :default => :package do
  puts "Don't forget to write some tests!"
end

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "rcov_rails"
  s.version           = "0.3.1"
  s.description       = "One Rake task to give you rcov code coverage for your rails app. rake test:coverage"
  s.summary           = "Ruby, Rails, Rcov put together into a single neat Rake task"
  s.author            = "Matthew Rudy Jacobs"
  s.email             = "matthewrudyjacobs@gmail.com"
  s.homepage          = "http://github.com/matthewrudy/rcov_rails"

  # Add any extra files to include in the gem
  s.files             = %w(MIT-LICENSE README) + Dir.glob("{lib/**/*}")
  s.require_paths     = ["lib"]

  s.add_dependency("rcov")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more 
# about that here: http://gemcutter.org/pages/gem_docs
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "generate the .gemspec file"
task :gemspec do
  # Generate the gemspec file for github.
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end


desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_package] do
  rm "#{spec.name}.gemspec"
end
