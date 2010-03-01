# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rcov_rails}
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Rudy Jacobs"]
  s.date = %q{2010-03-01}
  s.description = %q{One Rake task to give you rcov code coverage for your rails app. rake test:coverage}
  s.email = %q{matthewrudyjacobs@gmail.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["MIT-LICENSE", "README", "lib/rcov_rails", "lib/rcov_rails/railtie.rb", "lib/rcov_rails.rb", "lib/tasks", "lib/tasks/coverage.rake"]
  s.homepage = %q{http://github.com/matthewrudy/rcov_rails}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Ruby, Rails, Rcov put together into a single neat Rake task}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
