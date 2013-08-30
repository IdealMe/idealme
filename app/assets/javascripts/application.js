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
//= require select2.js
//= require best_in_place
//= require jquery.cookie
//= require bootstrap-tour
//= require users.js
//
//= require_tree .


$(function () {

    $('.select2').select2();

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
            data: {
                'goal_user_id': data_goal_user_id
            },
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

$(function () {
    var current_user_username = im_js.current_user_username;

    if (typeof current_user_username !== "undefined" && current_user_username != null && !im_js.current_user_toured) {

        var tour = new Tour({
            onEnd: function () {

                $.ajax({
                    url: '/ajax/users/' + current_user_username,
                    async: false,
                    type: 'PUT',
                    cache: false,
                    data: {
                        'user': {
                            'toured': '1'
                        }
                    },
                    dataType: 'json'
                });

            }
            //      template: "<div class='popover tour'><div class='arrow'></div><h3 class='popover-title'></h3><div class='popover-content'></div><nav class='popover-navigation'> <div class='btn-group'><button data-role='prev'>« Prev</button><button data-role='next'>Next »</button></div><button  data-role='end'>End tour</button> </nav></div>"
        });
        tour.addSteps([
            {
                path: "/bill",
                element: ".logo",
                placement: "bottom",
                title: "Hey Username! Welcome to Ideal Me",
                content: "Let's get you started in under a minute by showing you around..."

            },
            {
                path: "/bill",
                element: ".user-counters",
                placement: "bottom",
                title: "Your stats",
                content: "Track your progress, gems you collect and share, and supporters."
            },
            {
                element: ".goal-card:first",
                placement: "top",
                title: "Your goals",
                content: "Here are your goals. You can add more or mark them as done."
            },

            {
                path: "/discovers",
                element: "a.active",
                placement: "bottom",
                title: "Find inspiration and resources",
                content: "On the discover page you'll find all the latest gems, goals and courses sorted by popularity or the date they were added"

            },
            {
                path: "/markets",
                element: "a.active",
                placement: "bottom",
                title: "Find and buy courses you can trust",
                content: "In the marketplace you can explore featured, popular and recommended courses from IdealMe and our partners, reviewed and vetted by our members"

            },
            {
                path: "/bill",
                element: ".logo",
                placement: "bottom",
                title: "All done!",
                content: "Now get off to a good start by checking in for the first time..."

            }
// ,
//        {
//            element: "#usage",
//            placement: "top",
//            title: "Setup in four easy steps",
//            content: "Easy is better, right? Easy like Bootstrap.",
//            options: {
//                labels: {
//                    prev: "Go back",
//                    next: "Hey",
//                    end: "Stop"
//                }
//            }
//        },
//        {
//            element: "#options",
//            placement: "top",
//            title: "And it is powerful!",
//            content: "There are more options for those, like us, who want to do complicated things. " + "<br />Power to the people! :P",
//            reflex: true
//        },
//        {
//            element: "#demo",
//            placement: "top",
//            title: "A new shiny Backdrop option",
//            content: "If you need to highlight the current step's element, activate the backdrop " + "and you won't lose the focus anymore!",
//            backdrop: true
//        },
//        {
//            element: "#reflex",
//            placement: "bottom",
//            title: "Reflex mode",
//            content: "Reflex mode is enabled, click on the page heading to continue!",
//            reflex: true
//        },
//        {
//            path: "/page.html",
//            element: "h1",
//            placement: "bottom",
//            title: "See, you are not restricted to only one page",
//            content: "Well, nothing to see here. Click next to go back to the index page."
//        },
//        {
//            path: "/",
//            element: "#contribute",
//            placement: "bottom",
//            title: "Best of all, it's free!",
//            content: "Yeah! Free as in beer... or speech. Use and abuse, but don't forget to contribute!"
//        }
        ]);
        tour.start();
    }

});


$(function () {
    $('.sortable').sortable({
        axis: 'y',
        handle: '.handle',

        update: function () {
            console.log($(this).sortable('serialize'));
            $.post($(this).data('update-url'), $(this).sortable('serialize'));
        }
    });
});
