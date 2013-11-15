$(document).on 'click', 'a.reviews-link', (e) ->
  e.preventDefault()
  $('.tabs-nav a[href="#tab-3"]').click()
