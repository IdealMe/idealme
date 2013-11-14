namespace :payloads do
  desc "upload files from dropbox"
  task :upload => :environment do
    files = Dir.glob((`echo $HOME`.strip)+'/Dropbox/upload/**/*.*')
    files.each { |path| Payload.payload_from_path(path) }
  end

  desc "swap old payloads for new ones"
  task :swap => :environment do
    Payload.where(dropbox_path: nil).where("payloadable_id is not null").each { |payload|
      new_payload = Payload.where(payload_file_name: payload.payload_file_name).where("dropbox_path is not null").last
      if new_payload
        new_payload.intended_type = payload.intended_type
        new_payload.payloadable_id = payload.payloadable_id
        new_payload.payloadable_type = payload.payloadable_type

        payload.intended_type = nil
        payload.payloadable_id = nil
        payload.payloadable_type = nil

        new_payload.save!
        payload.save!
      end
    }
  end
end
