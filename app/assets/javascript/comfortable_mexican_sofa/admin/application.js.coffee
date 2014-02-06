#= require ckeditor/override
#= require ckeditor/init

window.CMS.wysiwyg = ->
  $els = $('textarea[data-cms-rich-text]')
  els = $els.get()
  debugger
  for el in els
    CKEDITOR.replace( el )



