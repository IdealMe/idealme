if (typeof jQuery !== 'undefined') {
  jQuery(function($) {
		$(document).ready(function(){
        // ****************************************** PLACEHOLDER
        function placeholder() { // placeholder for inputs textarea
          //placeholder for form
          $('input, textarea').focus(function() {
            if($(this).attr('placeholder') == $(this).val()){
                $(this).val('');
                $(this).data('placeholder', $(this).attr('placeholder'));
                $(this).attr('placeholder','');
            }
          });
          $('input, textarea').blur(function() {
            if ($(this).val() == '') {
              $(this).val($(this).data('placeholder'));
              $(this).attr('placeholder',$(this).data('placeholder'));
            }
          });
        };
        placeholder();
      $('.flexslider').flexslider({ // Slider - http://flexslider.woothemes.com/
        animation: "slide",
        controlNav: true,
        manualControls: ".control-nav button"
      });
      $('body').on('click', '.sign_in_toggle', function(){ // sign in/up toggle
        var sign_up_box = $('.sign_up_box'),
            sign_in_box = $('.sign_in_box');
        if(sign_up_box.hasClass('on')){
          sign_up_box.removeClass('on');
          sign_up_box.hide();
          sign_in_box.addClass('on');
          sign_in_box.show();
        }else{
          sign_in_box.removeClass('on');
          sign_in_box.hide();
          sign_up_box.addClass('on');
          sign_up_box.show();
        }
      })


      $("ul.tabs").tabs("div.panes > div"); // tabs - http://jquerytools.org/demos/tabs/index.html

      // GOAL ACTIVE LOSE WEIGHT PAGE
      var date = new Date(),
          day_of_week=date.getDay()-1,
          days_row = $('.days_row').first(),
          not_passed_days= null;
      days_row.find('div:eq('+day_of_week+')').addClass('today');
      days_row.find('div').each(function(){
        if( $(this).hasClass('today') ) not_passed_days = true;
        if( not_passed_days===true ) $(this).addClass('white');
      });

      $('body').on('click', '.btn-checkin', function(){
        var date = new Date(),
            day_of_week=date.getDay()-1,
            share_input = $('.share_input'),
            share_form = $('.share_section .input-append')
            checked_in_msg = $('.checked_in_msg'),
            no_checkins = $('.check_in_status .no_checkins'),
            checkined_in = $('.check_in_status .checkined_in'),
            checkined_numb_box = $('.check_in_numb .numb_icon'),
            checkined_numb = +checkined_numb_box.text(),
            checkin_day = $('.today');

        share_form.fadeOut(300, function(){
          checked_in_msg.fadeIn(300);
          checkin_day.addClass('checked');
          $(this).addClass('checkedIn')
        })
        no_checkins.fadeOut(300, function(){
          checkined_in.fadeIn(300);
          checkined_numb_box.text(checkined_numb+1).addClass('red')
        });
      });
      $('body').on('click', '.share_toggle', function(){
        var check_in_toggle = $('.check_in_toggle'),
            share_input = $('.share_input'),
            share_form = $('.share_section .input-append'),
            checked_in_msg = $('.checked_in_msg'),
            form_btn = $('.btn-checkin'),
            $this = $(this);

        check_in_toggle.removeClass('on');
        $this.addClass('on');
        share_input.val('Enter the link for a useful webpage, article, image, video, app, Tweet...');
        form_btn
          .text('ADD GEM')
          .removeClass('btn-checkin')
          .addClass('btn-addgem open_pop_up')
          .data({
            'popupname':'pop_up_example',
            'width':'600',
            'top':'146px'
          });
        checked_in_msg.fadeOut(300, function(){
          share_form.fadeIn(300);
        });
      });
      $('body').on('click', '.check_in_toggle', function(){
        var share_toggle = $('.share_toggle'),
            share_input = $('.share_input'),
            share_form = $('.share_section .input-append'),
            checked_in_msg = $('.checked_in_msg'),
            form_btn = $('.btn-addgem'),
            $this = $(this);

        share_toggle.removeClass('on');
        $this.addClass('on');
        share_input.val('Say how you make progress today...');
        form_btn.text('CHECK IN').removeClass('btn-addgem open_pop_up').addClass('btn-checkin');
        if(share_form.hasClass("checkedIn")){
          share_form.fadeOut(300, function(){
            checked_in_msg.fadeIn(300);
          });
        }
      });
      // GOAL ACTIVE LOSE WEIGHT PAGE END
      $('body').on('click', '.comment_count_box', function(){
        var $this = $(this),
            user_coments_box = $this.closest('.comment_body').find('.user_coments_box');
            write_comment_box = $this.closest('.comment').find('.write_comment_box');
            btn_red = $this.closest('.comment').find('.btn-red');
        if(!$(this).hasClass('on')){
          user_coments_box.slideDown(500);
          write_comment_box.slideDown(500);
          btn_red.slideDown(500);
          $(this).addClass('on');
        }else{
          user_coments_box.slideUp(500);
          write_comment_box.slideUp(500);
          btn_red.slideUp(500);
          $(this).removeClass('on');
        }
      });
    });
	});
};

$(function(){

    $('.goal_box').each(function(){
        $(this).on('click', function(e){
            $(this).find('.checked').toggle();
            e.preventDefault();
        })
    });


    $(".tabs .tab").hide();
    $(".tabs .tabs-nav li:first").addClass("active").show();
    $(".tabs .tab:first").show();

    $(".tabs .tabs-nav li").click(function() {
        $(".tabs .tabs-nav li").removeClass("active");
        $(this).addClass("active");
        $(".tabs .tab").hide();
        var activeTab = $(this).find("a").attr("href");
        $(activeTab).fadeIn();
        return false;
    });

    $('.datepicker').datepicker({
      format: 'yyyy-mm-dd',
      autoclose: true
    }).on('changeDate', function(evt){
      $('#btn-update-datefilters').addClass("btn-success")
    });

});
