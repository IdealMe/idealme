# A sample Guardfile
# More info at https://github.com/guard/guard#readme


guard 'ctags-bundler', :src_path => ["app", "lib", "spec/support"] do
  watch(/^(app|lib|spec\/support)\/.*\.rb$/)
  watch('Gemfile.lock')
end

guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

#guard 'livereload' do
  ##watch(%r{app/views/.+\.(erb|haml|slim)$})
  ##watch(%r{app/helpers/.+\.rb})
  ##watch(%r{public/.+\.(css|js|html)})
  #watch(%r{config/locales/.+\.yml})
  #watch(%r{(app|vendor)/.*})
  ## Rails Assets Pipeline
  ##watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html|sass|scss|less))).*}) { |m| "/assets/#{m[3]}" }
#end

guard :rspec, cmd: 'rspec -f doc', all_on_start: false, all_after_pass: false, run_all: { cmd: 'rspec -f doc' } do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/features/#{m[1]}_spec.rb" }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
end

#guard 'rails' do
#watch('Gemfile.lock')
#watch(%r{^(config|lib)/.*})
#end

### Guard::Sidekiq
#  available options:
#  - :verbose
#  - :queue (defaults to "default") can be an array
#  - :concurrency (defaults to 1)
#  - :timeout
#  - :environment (corresponds to RAILS_ENV for the Sidekiq worker)
#guard 'sidekiq', :environment => 'development', :concurrency => 1 do
  #watch('Gemfile.lock')
  #watch(%r{^(config|lib|app)/.*})
#end


guard 'livereload', :host=> 'localhost', :port=> '35721' do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
end
