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
  attr_reader :payload_remote_url

  # == Relationships ========================================================

  belongs_to :payloadable, polymorphic: true
  # == Paperclip ============================================================
  has_attached_file :payload, s3_permissions: :private

  # == Validations ==========================================================
  # == Scopes ===============================================================
  scope :unattached, -> { where(payloadable_id: nil).order('payload_file_name ASC') }
  # == Callbacks ============================================================
  # == Class Methods ========================================================
  def self.compute_payload_tags(base)
    payloads = Hash.new
    base.payloads.each { |payload| payloads["{im:model:payload:#{payload.id}}"] = payload }
    base.payloads.each { |payload| payloads["[payload_#{payload.id}]"] = payload }
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

  def self.payload_from_path(path)
    payload = Payload.new
    payload.payload = File.open path
    home = `echo $HOME`.strip
    dropbox_path = path.sub(home, '')
    existing = Payload.where(dropbox_path: dropbox_path).first
    unless existing
      payload.dropbox_path = dropbox_path
      payload.save!
      payload
    else
      existing
    end
  end

  def set_intended_type
    self.intended_type = IM_PAYLOAD_DOCUMENT if payload_file_name.include?('.pdf')
    self.intended_type = IM_PAYLOAD_ARCHIVE if payload_file_name.include?('.zip')
    self.intended_type = IM_PAYLOAD_VIDEO if payload_file_name.include?('.mov')
    self.intended_type = IM_PAYLOAD_VIDEO if payload_file_name.include?('.mp4')
    self.intended_type = IM_PAYLOAD_VIDEO if payload_file_name.include?('.flv')
    self.intended_type = IM_PAYLOAD_AUDIO if payload_file_name.include?('.mp3')
  end


  def payload_remote_url=(url_value)
    self.payload = URI.parse(url_value)
    # Assuming url_value is http://example.com/photos/face.png
    # avatar_file_name == "face.png"
    # avatar_content_type == "image/png"
    @payload_remote_url = url_value
  end

  def download_url
    payload.expiring_download_url(IM_S3_URL_TTL)
  end

  def select_label
    if dropbox_path.present?
      "#{payload_file_name} - #{short_dropbox_path}"
    else
      "#{payload_file_name}"
    end
  end

  def short_dropbox_path
    self.dropbox_path.sub('/Dropbox/upload/','')
  end


end
