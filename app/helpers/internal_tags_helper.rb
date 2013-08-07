module InternalTagsHelper
  def render_polls(polls, content)
    if polls && content
      polls.each do |key, payload|
        poll_render = capture do
          render :partial => '/partials/vote_widget', :locals => {:poll_question => payload}
        end
        content = content.gsub(key, poll_render)
      end
    end
    content
  end

  def render_payloads(payloads, content)
    if payloads && content
      payloads.each do |key, payload|
        payload_render = capture do
          if payload.intended_type ==IM_PAYLOAD_IMAGE
            render :partial => '/partials/amazon/image', :locals => {:s3_expiring => payload.payload.expiring_url(1800), :download => true}
          elsif payload.intended_type == IM_PAYLOAD_VIDEO
            render :partial => '/partials/amazon/video', :locals => {:s3_path => payload.payload.path, :s3_expiring => payload.payload.expiring_url(1800), :autoplay => true, :download => true}
          elsif payload.intended_type == IM_PAYLOAD_AUDIO
            render :partial => '/partials/amazon/audio', :locals => {:s3_expiring => payload.payload.expiring_url(1800), :download => true}
          elsif payload.intended_type == IM_PAYLOAD_DOCUMENT
            render :partial => '/partials/amazon/document', :locals => {:s3_expiring => payload.payload.expiring_url(1800), :download => true}
          elsif payload.intended_type == IM_PAYLOAD_ARCHIVE
            render :partial => '/partials/amazon/archive', :locals => {:s3_expiring => payload.payload.expiring_url(1800), :download => true}
          end
        end
        content = content.gsub(key, payload_render)
      end
    end
    content
  end
end