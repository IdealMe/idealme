class Review < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  # == Attributes ===========================================================
  # == Relationships ========================================================
  belongs_to :course
  belongs_to :owner, class_name: 'User'

  # == Paperclip ============================================================
  # == Validations ==========================================================
  validates_presence_of :title
  validates_presence_of :content

  # == Scopes ===============================================================
  # == Callbacks ============================================================
  after_create :after_create
  before_destroy :before_destroy

  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  def after_create
    if recommended
      course.review_positive += 1
    else
      course.review_negative += 1
    end
    course.save!
  end

  def before_destroy
    if recommended
      course.review_positive += 1
    else
      course.review_negative += 1
    end
    course.save!
  end
end
