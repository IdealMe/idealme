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
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  after_create :after_create
  before_destroy :before_destroy

  # == Class Methods ========================================================
  # == Instance Methods =====================================================
  def after_create
    if self.recommended
      self.course.review_positive += 1
    else
      self.course.review_negative += 1
    end
    self.course.save!
  end

  def before_destroy
    if self.recommended
      self.course.review_positive += 1
    else
      self.course.review_negative += 1
    end
    self.course.save!
  end
end
