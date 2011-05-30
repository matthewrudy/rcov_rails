# this is what a Rails test looks like
# copy it;
#
# Rake::TestTask.new(:units => "db:test:prepare") do |t|
#   t.libs << "test"
#   t.pattern = 'test/unit/**/*_test.rb'
#   t.verbose = true
# end
# Rake::Task['test:units'].comment = "Run the unit tests in test/unit"
#

begin

  require File.expand_path(File.join(File.dirname(__FILE__), "..", "rcov_rails/rcovtask"))

  def coverage_task(name, aspects, task_description)
    aspect_tasks = Array(aspects).map{ |aspect| "test:coverage:_#{aspect}" }

    desc(task_description)
    
    task name => ["test:coverage:reset"] + aspect_tasks do
      
      generator_task = if aspects == :units
        "generate_without_controllers"
      else
        "generate"
      end
      
      Rake::Task["test:coverage:#{generator_task}"].invoke()
      
      if defined?(RUBY_PLATFORM) && RUBY_PLATFORM['darwin']
        system("open coverage/index.html")
      else
        puts "coverage created. open coverage/index.html in a web browser"
      end
    end
  end

  namespace :test do

    namespace :coverage do
      
      task_dependencies = []
      
      # in Rails 2, ActiveRecord is not loaded at this point
      # but also, rake db:test:prepare is globally defined, and deals with ActiveRecord's status itself
      # so its safe to add it as a dependency even if ActiveRecord is not defined.
      #
      # in Rails 3, I believe we can't include the db:test:prepare if ActiveRecord is not in the stack
      # (the db:test:prepare task is only defined in the rake tasks which live inside activerecord, and are loaded by its railtie)
      
      in_rails2 = defined?(Rails) && Rails::VERSION::MAJOR == 2
      
      if in_rails2 || defined?(ActiveRecord)
        task_dependencies << "db:test:prepare"
      end

      ["units", "functionals", "integration"].each do |scope|
        RcovRails::RcovTask.new("_#{scope}" => task_dependencies) do |t|
          t.libs << "test"
          t.test_files = Dir["test/#{scope.singularize}/**/*_test.rb"]
          t.add_descriptions = false
          t.rcov_opts = ["--no-html", "--aggregate coverage.data"]
        end
        
        coverage_task(scope, scope.to_sym, "run the #{scope} tests with coverage")
      end

      task :reset do
        rm_f "coverage.data"
        rm_f "coverage"
      end

      RcovRails::RcovTask.new(:generate) do |t|
        t.libs << "test"
        t.test_files = []
        t.add_descriptions = false
        t.rcov_opts = ["--html", "--aggregate coverage.data", "--exclude '^(?!(app|lib))'"]
      end
      
      RcovRails::RcovTask.new(:generate_without_controllers) do |t|
        t.libs << "test"
        t.test_files = []
        t.add_descriptions = false
        t.rcov_opts = ["--html", "--aggregate coverage.data", "--exclude '^(?!(app|lib))'", "--exclude '^app[\\/\/]controllers'"]
      end

    end

    coverage_task(:coverage, [:units, :functionals, :integration], "run all the tests with coverage")

  end

rescue LoadError
  
  namespace :test do
    task :coverage do
      puts "You must install the 'rcov' gem to use rcov_rails\n\tsudo gem install rcov"
    end
  end
  
end
