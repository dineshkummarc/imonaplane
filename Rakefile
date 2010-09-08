require 'spec/rake/spectask'
require 'cucumber/rake/task'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
  t.spec_opts << '--format progress --color'
end

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = "features --format progress"
end

task :default => [:spec, :cucumber] do
end
