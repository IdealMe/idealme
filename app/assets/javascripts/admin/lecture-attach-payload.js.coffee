class LectureAttachPayload

  constructor: ->
    $(document).on 'click', '.attach-payload-button', @attachPayloadHandler


  attachPayloadHandler: ->
    $this = $(this)
    payloadId = $this.closest('.attach-payload-container').find('#attach_payload_id').val()
    lectureId = $('#hidden-lecture-id').val()
    $.post("/admin/lectures/#{lectureId}/attach_payload", { payload_id: payloadId })
    .done (response)->
      $('.payloads-controls').html(response)

new LectureAttachPayload

class LectureRemovePayload

  constructor: ->
    $(document).on 'click', '.remove-lecture-payload-button', @removePayloadHandler


  removePayloadHandler: ->
    $this = $(this)
    $this.closest('tr').fadeOut()

new LectureRemovePayload
