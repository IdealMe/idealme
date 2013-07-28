class Jewel < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  attr_accessible :name, :slug, :content, :url, :avatar, :owner_id

  # == Relationships ========================================================
  belongs_to :owner, :class_name => 'User'
  has_many :goal_user_jewel
  has_many :goals, :through => :goal_user_jewel

  # == Paperclip ============================================================
  has_attached_file :avatar,
                    :styles => {:full => '252x202#', :thumb => '80x64#'},
                    :convert_options => {
                        :full => '-gravity center -extent 252x202 -quality 75 -strip',
                        :thumb => '-gravity center -extent 80x64 -quality 75 -strip'
                    }

  # == Validations ==========================================================

  # == Scopes ===============================================================
  scope :private_goal, lambda { |permission| joins(:goal_user_jewel => :goal_user).where(:goal_users => {:private => permission}) }
  scope :for_goal, lambda { |goal| joins(:goal_user_jewel => :goal_user).where(:goal_user_jewels => {:goal_id => goal.id}) }
  scope :for_user, lambda { |user| joins(:goal_user_jewel => :goal_user).where(:goal_users => {:user_id => user.id}) }

  # == Callbacks ============================================================
  before_validation :scrub_url
  before_save :inspect_and_set_meta

  # == Class Methods ========================================================
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

  # == Instance Methods =====================================================
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

end
