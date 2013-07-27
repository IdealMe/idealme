class Jewel < ActiveRecord::Base
  attr_accessible :name, :slug, :content, :url, :avatar, :owner_id

  before_validation :scrub_url

  before_save :inspect_and_set_meta

  belongs_to :owner, :class_name => 'User'

  has_attached_file :avatar,
                    :styles => {:full => '252x202#', :thumb => '80x64#'},
                    :convert_options => {
                        :full => '-gravity center -extent 252x202 -quality 75 -strip',
                        :thumb => '-gravity center -extent 80x64 -quality 75 -strip'
                    }


  def scrub_url
    scrub = ['utm_source', 'utm_medium', 'utm_campaign', 'utm_content']
    uri = URI(self.url)
    clean = "#{uri.scheme}://#{uri.hostname}#{uri.path}"

    queries = Rack::Utils.parse_nested_query(uri.query).except(*scrub).to_query

    clean << "?#{queries}" if queries && queries.length > 0

    self.url = clean
  end

  def inspect_and_set_meta

  end


  def self.mine(user, url)
    gem = Jewel.new
    gem.url = url
    gem.owner_id = user.id
    gem.scrub_url

    page = MetaInspector.new(url)
    gem.name = page.title
    gem.content = page.description
    gem.avatar = URI.parse(page.image) if page.image
    gem.save!
    gem
  end
end
