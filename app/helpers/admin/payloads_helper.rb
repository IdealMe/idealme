# Helper for generated path methods for the payloads class
#
# @see Payload
module Admin::PayloadsHelper
  # Relative path helper for displaying a list of payloads
  #
  # @todo What is the parameter *payload* used for?
  # @param [?] payload nil
  # @return [String] The relative path to the list of payloads with respect to *Market*, *Lecture*, or *Article*
  # @see Market
  # @see Lecture
  # @see Article
  def admin_payloads_path(payload = nil)
    case @payload_parent.class.name
      when 'Market'
        admin_market_payloads_path(@payload_parent)
      when 'Lecture'
        admin_lecture_payloads_path(@payload_parent)
      when 'Article'
        admin_article_payloads_path(@payload_parent)
    end
  end

  # Relative path helper for displaying a single payload
  #
  # @todo What is the parameter *payload* used for?
  # @param [Payload] payload The payload to be displayed
  # @param [Symbol] format The format of the relative path, this is usually is not always, HTML
  # @return [String] The relative path to the list of payloads with respect to *Market*, *Lecture*, or *Article*
  # @see Market
  # @see Lecture
  # @see Article
  def admin_payload_path(payload, format = nil)
    case @payload_parent.class.name
      when 'Market'
        admin_market_payload_path(@payload_parent, payload, format)
      when 'Lecture'
        admin_lecture_payload_path(@payload_parent, payload, format)
      when 'Article'
        admin_article_payload_path(@payload_parent, payload, format)
    end
  end

  # Relative path helper for edit a single payload
  #
  # @todo What is the parameter *payload* used for?
  # @param [Payload] payload The payload to be displayed
  # @return [String] The relative path for editing a payload with respect to *Market*, *Lecture*, or *Article*
  # @see Market
  # @see Lecture
  # @see Article
  def edit_admin_payload_path(payload)
    case @payload_parent.class.name
      when 'Market'
        edit_admin_market_payload_path(@payload_parent, payload)
      when 'Lecture'
        edit_admin_lecture_payload_path(@payload_parent, payload)
      when 'Article'
        edit_admin_article_payload_path(@payload_parent, payload)
    end
  end

  # Relative path helper for creating a single payload
  #
  # @todo What is the parameter *payload* used for?
  # @return [String] The relative path for creating a single payload with respect to *Market*, *Lecture*, or *Article*
  # @see Market
  # @see Lecture
  # @see Article
  def new_admin_payload_path
    case @payload_parent.class.name
      when 'Market'
        new_admin_market_payload_path(@payload_parent)
      when 'Lecture'
        new_admin_lecture_payload_path(@payload_parent)
      when 'Article'
        new_admin_article_payload_path(@payload_parent)
    end
  end
end
