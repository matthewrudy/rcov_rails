require 'rails'
module RcovRails
  class Railtie < Rails::Railtie
    railtie_name :rcov_rails

    rake_tasks do
      load "lib/tasks/coverage.rake"
    end
  end
end
