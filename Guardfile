notification :off

guard 'rake', :task => 'run' do
  watch(%r{^my_file.rb})
end

guard :rspec, cmd: "bundle exec rspec --exclude-pattern spec/property/*_spec.rb" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)
end

# vim: set ft=ruby
