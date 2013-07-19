// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require modernizr-2.6.2-respond-1.1.0.min.js
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.flexslider
//= require formatted_form
//= require tinymce-jquery
//= require_tree .


$(function () {
    // ****************************************** PLACEHOLDER
    function placeholder() { // placeholder for inputs textarea
        //placeholder for form
        $('input, textarea').focus(function () {
            if ($(this).attr('placeholder') == $(this).val()) {
                $(this).val('');
                $(this).data('placeholder', $(this).attr('placeholder'));
                $(this).attr('placeholder', '');
            }
        });
        $('input, textarea').blur(function () {
            if ($(this).val() == '') {
                $(this).val($(this).data('placeholder'));
                $(this).attr('placeholder', $(this).data('placeholder'));
            }
        });
    };
    placeholder();
    $('.flexslider').flexslider({
        animation: "slide",
        controlNav: true,
        manualControls: ".control-nav button"
    });

});

