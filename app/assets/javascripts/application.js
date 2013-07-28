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
//= require jquery.ui.all
//= require twitter/bootstrap
//= require jquery.flexslider
//= require formatted_form
//= require tinymce-jquery
//= require jquery.stayInWebApp.js
//= require jstz-1.0.5.js
//
//= require best_in_place
//
//= require users.js
//
//= require_tree .


$(function () {
    $('.goal-privacy-toggle').click(function () {
        var self = $(this);
        var data_goal_user_id = self.attr('data-goal-user-id');
        var data_goal_user_private = self.attr('data-goal-user-private');
        if (data_goal_user_private == 1) {
            self.attr('data-goal-user-private', 0);
            self.html('Public');
        } else {
            self.attr('data-goal-user-private', 1);
            self.html('Private');
        }
        $.ajax({
            type: "POST",
            url: '/ajax/goal_users/set_privacy',
            data: {'goal_user_id': data_goal_user_id},
            //success: success,
            dataType: 'json'
        });
    });
});

$(function () {
    $('.user-avatar').click(function () {
        var user_menu = $(this).siblings('.user-menu');

        var $this = $(this);
        if ($this.hasClass('on')) {
            $this.removeClass('on');
            user_menu.hide();
        } else {
            $this.addClass('on');
            user_menu.show();
        }
    });

    $.stayInWebApp();


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

    $('.flexslider').flexslider({
        animation: "slide",
        controlNav: true,
        manualControls: ".control-nav button"
    });

});