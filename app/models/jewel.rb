class DuplicateJewel < Exception
  attr_accessor :jewel
end

class Jewel < ActiveRecord::Base
  serialize :parameters

  # == Imports ==============================================================
  extend FriendlyId
  include Votable

  # == Slug =================================================================
  friendly_id :name, use: [:history, :slugged, :finders]

  # == Constants ============================================================
  TYPES = HashWithIndifferentAccess.new(
    course: 0,
    article: 1,
    video: 2,
    product: 3,
  )

  # == Relationships ========================================================
  belongs_to :owner, class_name: 'User'
  has_many :goal_user_jewel
  has_many :goals, through: :goal_user_jewel


  belongs_to :linked_course, primary_key: :id, foreign_key: :course_id, class_name: 'Course'

  belongs_to :linked_goal, primary_key: :id, foreign_key: :goal_id, class_name: 'Goal'


  has_many :comments, as: :commentable, dependent: :destroy
  has_many :replies, through: :comments

  # == Paperclip ============================================================
  if Rails.env.development? || Rails.env.test?
    storage = :filesystem
  else
    storage = :s3
  end
  has_attached_file :avatar,
                    storage: storage,
                    styles: {full: '229x201#', thumb: '80x64#', bigger: '525x525#'},
                    convert_options: {
                        full: '-gravity center -extent 229x201 -quality 75 -strip',
                        bigger: '-gravity center -extent 525x525 -quality 75 -strip',
                        thumb: '-gravity center -extent 80x64 -quality 75 -strip'
                    }

  # == Validations ==========================================================

  # == Scopes ===============================================================
  scope :private_goal, lambda { |permission| joins(goal_user_jewel: :goal_user).where(goal_users: {private: permission}) }
  scope :for_goal, lambda { |goal| joins(goal_user_jewel: :goal_user).where(goal_user_jewels: {goal_id: goal.id}) }
  scope :for_user, lambda { |user| joins(goal_user_jewel: :goal_user).where(goal_users: {user_id: user.id}) }

  # == Callbacks ============================================================
  before_validation :scrub_url
  before_save :inspect_and_set_meta

  # == Class Methods ========================================================
  def self.mine(user, url, goal = nil)
    if gem = Jewel.where(visible: true, url: Jewel.scrub_url(url), linked_goal: goal).first
      e = DuplicateJewel.new('That jewel already exists')
      e.jewel = gem
      raise e
    else
      gem             = Jewel.new
      gem.url         = url
      gem.owner_id    = user.id
      gem.linked_goal = goal if goal
      gem.fetch!
    end
  end

  def self.get_service(url)
    uri = URI(url)

    if uri.host.include?('idealme.dev') || uri.host.include?('idealme.com')
      segments = uri.path.split('/')
      if segments.second == 'markets' || segments.second == 'courses'
        return {service: :idealme, kind: :courses, slug: segments.third}
      elsif segments.second == 'goals'
        return {service: :idealme, kind: :goals, slug: segments.third}
      end
    elsif uri.host.include?('twitter.com')
      segments = uri.path.split('/')
      if segments.third == 'status' && segments.fourth.present?
        return {service: :twitter_status, status_id: segments.fourth}
      end
    elsif uri.host.include?('youtube.com')
      segments = uri.path.split('/')
      if segments.second == 'watch'

        queries = Rack::Utils.parse_nested_query(uri.query)

        return {service: :youtube, url: url, youtube_id: queries['v']}
      end
    end


    {service: :other, url: url}
  end

  # == Instance Methods =====================================================
  def fetch!
    self.scrub_url

    parameters      = Jewel.get_service(self.url)
    self.parameters  = parameters

    if parameters[:service] == :twitter_status
      twitter     = Twitter.status(parameters[:status_id])
      self.name    = "Tweet from #{twitter.user.name}"
      self.name    = twitter.text
      self.content = twitter.text
      tweet_media = twitter.media
      if tweet_media.length > 0
        self.avatar = URI.parse(tweet_media.first.media_url)
      end
      self.kind = Jewel::TYPES[:link]
    elsif parameters[:service] == :other
      page        = MetaInspector.new(url)
      self.name    = page.title
      self.content = page.description
      self.avatar  = URI.parse(page.image) if page.image
      self.kind    = Jewel::TYPES[:link]
    elsif parameters[:service] == :youtube
      page        = MetaInspector.new(url)
      self.name    = page.title
      self.content = page.description
      self.avatar  = URI.parse(page.image) if page.image
      self.kind    = Jewel::TYPES[:link]
    elsif parameters[:service] == :idealme
      if parameters[:kind] ==:courses
        self.kind      = Jewel::TYPES[:course]
        course        = Course.where(slug: parameters[:slug]).first
        self.course_id = course.id
      elsif parameters[:kind] ==:goals
        self.kind    = Jewel::TYPES[:goal]
        goal        = Goal.where(id: parameters[:slug]).first
        self.goal_id = goal.id
      end
    end

    self.save!
    self

  end

  def self.scrub_url(url)
    scrub = ['utm_source', 'utm_medium', 'utm_campaign', 'utm_content']
    uri = URI(url)
    clean = "#{uri.scheme}://#{uri.hostname}#{uri.path}"

    queries = Rack::Utils.parse_nested_query(uri.query).except(*scrub).to_query

    clean << "?#{queries}" if queries && queries.length > 0

    clean
  end

  def scrub_url
    self.url = Jewel.scrub_url(self.url)
  end

  def inspect_and_set_meta

  end

end
