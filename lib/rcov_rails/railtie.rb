require 'rails'
module RcovRails
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/coverage.rake"
    end
  end
end
