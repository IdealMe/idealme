cms = Cms::Site.create!(:label => 'idealme', :identifier => 'idealme', :hostname => 'idealme.com',
                        :path => '/', :locale => 'en', :is_mirrored => false)
if Rails.env.staging?
  cms.hostname = 'idealmedev.com'
elsif Rails.env.development?
  cms.hostname = 'idealme.dev'
end
cms.save!