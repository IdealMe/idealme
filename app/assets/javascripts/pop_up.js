if (typeof jQuery !== 'undefined') {
  jQuery(function($) {
    $(document).ready(function(){
      var popupName='';
      $(document).on("click", ".open_pop_up", function() {
        var marginLeft, top, width,
            top = $(this).data("top"),
            width = $(this).data("width"),
            marginLeft = -(Number(width) / 2);
            popupName = '.' + $(this).data("popupname");
        $("body").append("<div class=\"pop_up_bg\"></div>");
        $('.pop_up_bg').css({
          background: "#fff",
          width: "100%",
          height: "100%",
          position: "fixed",
          display: "none",
          top: "0",
          left: "0",
          "z-index": "1000",
          opacity: "0.5"
        });
        $(popupName).css({
          width: width,
          top: top,
          left: "50%",
          marginLeft: marginLeft
        });
        $(".pop_up_bg").fadeIn();
        $(popupName).fadeIn();
        return popupName;
      });
      $(document).on("click", ".close_pop_up", function() {
        $(".pop_up_bg").remove();
        $(popupName).fadeOut();
      })
    });
  });
};
