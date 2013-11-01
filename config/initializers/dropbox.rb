Dropbox::API::Config.app_key    = ENV['DROPBOX_TOKEN']
Dropbox::API::Config.app_secret = ENV['DROPBOX_SECRET']
Dropbox::API::Config.mode       = "dropbox" # if you have a single-directory app or "dropbox" if it has access to the whole dropbox