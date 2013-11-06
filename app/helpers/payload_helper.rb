module PayloadHelper

  def render_payload(payload)
    case payload.intended_type
      when IM_PAYLOAD_DOCUMENT
        render(partial: "partials/pdf", locals: { payload: payload })

      when IM_PAYLOAD_VIDEO
        render(partial: "partials/video", locals: { payload: payload })

      when IM_PAYLOAD_ARCHIVE
        render(partial: "partials/archive", locals: { payload: payload })

      when IM_PAYLOAD_IMAGE
        render(partial: "partials/image", locals: { payload: payload })

      when IM_PAYLOAD_AUDIO
        render(partial: "partials/audio", locals: { payload: payload })
    end
  end

end