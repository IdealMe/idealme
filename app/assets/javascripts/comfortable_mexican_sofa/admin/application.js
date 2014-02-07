//= require ckeditor/override
//= require ckeditor/init

window.CMS.wysiwyg = function() {
  $els = $('textarea[data-cms-rich-text]');
  els = $els.get();
  for (var i = 0; i < els.length; i++) {
    CKEDITOR.replace( els[i] );
  }
}



