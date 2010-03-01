require 'rails'
module RcovRails
  class Railtie < Rails::Railtie
    railtie_name :rcov_rails
    
    rake_tasks do
      load "tasks/coverage.rake"
    end
  end
end
