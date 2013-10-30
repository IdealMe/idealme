class Jewel < ActiveRecord::Base
  serialize :parameters

  # == Imports ==============================================================
  extend FriendlyId
  include Votable

  # == Slug =================================================================
  friendly_id :name, use: [:history, :slugged]

  # == Constants ============================================================
  EVERYTHING = 0
  LINK = 1
  GOAL = 2
  COURSE = 3
  # == Attributes ===========================================================
  attr_accessible :name, :slug, :content, :url, :avatar, :owner_id, :up_votes, :down_votes, :kind, :course, :course_id, :parameters

  def kind_to_s
    if self.kind == Jewel::EVERYTHING
      '???'
    elsif self.kind == Jewel::LINK
      'Link'
    elsif self.kind == Jewel::GOAL
      'Goal'
    elsif self.kind == Jewel::COURSE
      'Course'
    end
  end

  # == Relationships ========================================================
  belongs_to :owner, class_name: 'User'
  has_many :goal_user_jewel
  has_many :goals, through: :goal_user_jewel


  belongs_to :linked_course, primary_key: :id, foreign_key: :course_id, class_name: 'Course'

  belongs_to :linked_goal, primary_key: :id, foreign_key: :goal_id, class_name: 'Goal'


  has_many :comments, as: :commentable, dependent: :destroy
  has_many :replies, through: :comments

  # == Paperclip ============================================================
  has_attached_file :avatar,
                    styles: {full: '252x202#', thumb: '80x64#'},
                    convert_options: {
                        full: '-gravity center -extent 252x202 -quality 75 -strip',
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
  def self.mine(user, url)
    gem = Jewel.new
    gem.url = url
    gem.owner_id = user.id
    gem.scrub_url

    parameters = Jewel.get_service(gem.url)
    gem.parameters = parameters

    if parameters[:service] == :twitter_status
      twitter = Twitter.status(parameters[:status_id])
      gem.name = "Tweet from #{twitter.user.name}"
      gem.name = twitter.text
      gem.content = twitter.text
      tweet_media = twitter.media
      if tweet_media.length > 0
        gem.avatar = URI.parse(tweet_media.first.media_url)
      end

      gem.kind = Jewel::LINK
    elsif parameters[:service] == :other
      page = MetaInspector.new(url)
      gem.name = page.title
      gem.content = page.description
      gem.avatar = URI.parse(page.image) if page.image
      gem.kind = Jewel::LINK

    elsif parameters[:service] == :youtube
      page = MetaInspector.new(url)
      gem.name = page.title
      gem.content = page.description
      gem.avatar = URI.parse(page.image) if page.image
      gem.kind = Jewel::LINK


    elsif parameters[:service] == :idealme
      if parameters[:kind]==:courses
        gem.kind = Jewel::COURSE
        course = Course.where(slug: parameters[:slug]).first
        gem.course_id = course.id
      elsif parameters[:kind]==:goals
        gem.kind = Jewel::GOAL
        goal = Goal.where(id: parameters[:slug]).first
        gem.goal_id = goal.id
      end
    end


    gem.save!
    gem
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
