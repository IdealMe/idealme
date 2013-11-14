namespace :payloads do
  desc "upload files from dropbox"
  task :upload => :environment do
    files = Dir.glob((`echo $HOME`.strip)+'/Dropbox/upload/**/*.*')
    files.each { |path| Payload.payload_from_path(path) }
  end
end
