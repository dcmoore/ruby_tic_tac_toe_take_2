require 'rspec/core/rake_task'

namespace :spec do
  desc "Run specs with RCov"
  RSpec::Core::RakeTask.new('rcov') do |spec|
    spec.pattern = FileList['/Users/dcmoore/Projects/ruby_tic_tac_toe/ruby_tic_tac_toe/spec/**/*_spec.rb']
    spec.rcov = true
  end
end