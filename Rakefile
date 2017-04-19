require 'rake'
require 'rspec/core/rake_task'

desc 'Run the m2bf converter title tests'
RSpec::Core::RakeTask.new(:m2bf_titles) do |t|
  t.pattern = Dir.glob('spec/titles/')
  t.rspec_opts = '--tag bf --require m2bf_helper.rb'
end

desc 'Run the m2bf2 converter title tests'
RSpec::Core::RakeTask.new(:m2bf2_titles) do |t|
  t.pattern = Dir.glob('spec/titles/')
  t.rspec_opts = '--tag bf2 --require m2bf2_helper.rb'
end

desc 'Run the bib2lod converter title tests'
RSpec::Core::RakeTask.new(:bib2lod_titles) do |t|
  t.pattern = Dir.glob('spec/titles/')
  t.rspec_opts = '--tag bib2lod --require bib2lod_helper.rb'
end
