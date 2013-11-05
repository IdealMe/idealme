class ExpandingText

  constructor: ->
    $(document).on 'click', '.more-link', @expandTextHandler
    $(document).on 'click', '.less-link', @contractTextHandler

  expandTextHandler: ->
    $this = $(this)
    $container = $this.closest('.expandable-text')
    $container.find('.long-text').removeClass('hidden')
    $container.find('.short-text').addClass('hidden')
    $this.addClass('hidden')
    $container.find('.less-link').removeClass('hidden')

  contractTextHandler: ->
    $this = $(this)
    $container = $this.closest('.expandable-text')
    $container.find('.long-text').addClass('hidden')
    $container.find('.short-text').removeClass('hidden')
    $this.addClass('hidden')
    $container.find('.more-link').removeClass('hidden')

new ExpandingText