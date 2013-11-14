namespace :payloads do
  desc "upload files from dropbox"
  task :upload => :environment do
    files = Dir.glob('~/Dropbox/upload')
    binding.pry
  end
end
