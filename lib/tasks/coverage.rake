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
    aspect_tasks = aspects.map{ |aspect| "test:coverage:_#{aspect}" }

    desc(task_description)
    
    task name => ["test:coverage:reset"] + aspect_tasks + ["test:coverage:generate"] do
      if defined?(RUBY_PLATFORM) && RUBY_PLATFORM['darwin']
        system("open coverage/index.html")
      else
        puts "coverage created. open coverage/index.html in a web browser"
      end
    end
  end

  namespace :test do

    namespace :coverage do

      ["units", "functionals", "integration"].each do |scope|
        RcovRails::RcovTask.new("_#{scope}" => "db:test:prepare") do |t|
          t.libs << "test"
          t.test_files = Dir["test/#{scope.singularize}/**/*_test.rb"]
          t.add_descriptions = false
          t.rcov_opts = ["--no-html", "--aggregate coverage.data", "--exclude '^(?!(app|lib))'"]
        end
        
        coverage_task(scope, [scope], "run the #{scope} tests with coverage")
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
