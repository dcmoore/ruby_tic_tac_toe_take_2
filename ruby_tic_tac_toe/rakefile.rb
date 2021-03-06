require 'rspec/core/rake_task'

namespace :spec do
  desc "Run specs with RCov"
  RSpec::Core::RakeTask.new('rcov') do |spec|
    spec.pattern = FileList['spec/**/*_spec.rb']
    spec.rcov = true
    spec.rcov_opts = "--exclude osx\/objc,gems\/,spec\/,features\/"
  end
end