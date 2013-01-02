# encoding: utf-8

namespace :metrics do
  lib = RUBY_VERSION < '1.9' ? 'rcov' : 'simplecov'

  begin
    require lib

    if lib == 'rcov'
      require 'rspec/core/rake_task'

      desc 'Generate code coverage'
      RSpec::Core::RakeTask.new(:coverage) do |rcov|
        rcov.rcov      = true
        rcov.pattern   = 'spec/unit/**/*_spec.rb'
        rcov.rcov_opts = %w[
          --exclude-only "spec/,^/"
          --sort coverage
          --callsites
          --xrefs
          --profile
          --text-summary
          --failure-threshold 100
        ]
      end
    else
      desc 'Generate code coverage'
      task :coverage do
        begin
          original, ENV['COVERAGE'] = ENV['COVERAGE'], 'true'
          Rake::Task['spec:unit'].execute
        ensure
          ENV['COVERAGE'] = original
        end
      end
    end
  rescue LoadError
    task :coverage do
      $stderr.puts "coverage is not available. In order to run #{lib}, you must: gem install #{lib}"
    end
  end
end
