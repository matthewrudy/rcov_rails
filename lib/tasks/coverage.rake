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

  require 'rcov/rcovtask'

  def coverage_task(name, aspects, options={})
    aspect_tasks = aspects.map{ |aspect| "test:coverage:_#{aspect}" }

    if options[:description]
      desc options[:description]
    end
    
    task name => ["test:coverage:reset"] + aspect_tasks + ["test:coverage:generate"] do
      if PLATFORM['darwin']
        system("open coverage/index.html")
      else
        puts "coverage created. open coverage/index.html in a web browser"
      end
    end
  end

  namespace :test do

    namespace :coverage do

      ["units", "functionals", "integration"].each do |scope|
        Rcov::RcovTask.new("_#{scope}" => "db:test:prepare") do |t|
          t.libs << "test"
          t.test_files = Dir["test/#{scope.singularize}/**/*_test.rb"]
          t.rcov_opts = ["--no-html", "--aggregate coverage.data", "--exclude '^(?!(app|lib))'"]
        end
        
        coverage_task(scope, [scope], :description => "run the #{scope} tests with coverage")
      end

      task :reset do
        rm_f "coverage.data"
        rm_f "coverage"
      end

      Rcov::RcovTask.new(:generate) do |t|
        t.libs << "test"
        t.test_files = []
        t.rcov_opts = ["--html", "--aggregate coverage.data", "--exclude '^(?!(app|lib))'"]
      end

    end

    coverage_task(:coverage, [:units, :functionals, :integration])

  end

rescue LoadError
  "You must install the 'rcov' gem to use rcov_rails\n\tsudo gem install rcov"
end
