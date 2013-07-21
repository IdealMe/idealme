class Payload < ActiveRecord::Base
  # == Imports ==============================================================
  # == Slug =================================================================
  # == Constants ============================================================
  PAYLOAD_TYPE = [['Image', IM_PAYLOAD_IMAGE],
                  ['Video', IM_PAYLOAD_VIDEO],
                  ['Audio', IM_PAYLOAD_AUDIO],
                  ['Document', IM_PAYLOAD_DOCUMENT],
                  ['Archive', IM_PAYLOAD_ARCHIVE]]

  # == Attributes ===========================================================
  attr_accessible :payload, :intended_type, :payloadable_id, :payloadable_type

  # == Relationships ========================================================

  belongs_to :payloadable, :polymorphic => true
  # == Paperclip ============================================================
  has_attached_file :payload, :s3_permissions => :private

  # == Validations ==========================================================
  # == Scopes ===============================================================
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  def self.compute_payload_tags(base)
    payloads = Hash.new
    base.payloads.each { |payload| payloads["{im:model:payload:#{payload.id}}"] = payload }
    payloads
  end

  # == Instance Methods =====================================================

  def intended_type_to_s
    case self.intended_type
      when IM_PAYLOAD_IMAGE
        'Image'
      when IM_PAYLOAD_VIDEO
        'Video'
      when IM_PAYLOAD_AUDIO
        'Audio'
      when IM_PAYLOAD_DOCUMENT
        'Document'
      when IM_PAYLOAD_ARCHIVE
        'Archive'
    end
  end


end
