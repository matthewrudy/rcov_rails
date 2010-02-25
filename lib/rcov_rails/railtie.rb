require 'rails'
module RcovRails
  class Railtie < Rails::Railtie
    railtie_name :rcov_rails
    
    def tasks_path
      Dir.expand_path(File.join(File.dirname(__FILE__), "..", "tasks"))
    end

    rake_tasks do
      load File.join(File.dirname(__FILE__), "..", "tasks", "coverage.rake")
    end
  end
end
