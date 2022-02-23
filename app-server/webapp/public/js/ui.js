(function($) {
  "use strict"; // Start of use strict

  // Toggle the side navigation
  // $("#sidebarToggle, #sidebarToggleTop").on('click', function(e) {
  //   $("body").toggleClass("sidebar-toggled");
  //   $(".sidebar").toggleClass("toggled");
    
  //   if ($(".sidebar").hasClass("toggled")) {
  //     $('.sidebar .collapse').collapse('hide');
  //   };
  // });

  // Save the state of side navigation to local storage
  // $(document).on('ready', function(e) {
  //   let sidebarToggleButton = $('#sidebarToggle');
  //   if (sidebarToggleButton) {
  //     $("#sidebarToggle").on('click', function(e) {
  //       // e.preventDefault();
  //       let isToggled = $('.sidebar').hasClass('toggled');
  //       window.localStorage.setItem('IS_TOGGLED', !isToggled);
  //     });
  //   }
  // });

  // Close any open menu accordions when window is resized below 768px
  $(window).on('resize', function() {
    if ($(window).width() < 768) {
      $('.sidebar .collapse').collapse('hide');
    };
    
    // Toggle the side navigation when window is resized below 480px
    if ($(window).width() < 480 && !$(".sidebar").hasClass("toggled")) {
      $("body").addClass("sidebar-toggled");
      $(".sidebar").addClass("toggled");
      $('.sidebar .collapse').collapse('hide');
    };
  });

  // Prevent the content wrapper from scrolling when the fixed side navigation hovered over
  $('body.fixed-nav .sidebar').on('mousewheel DOMMouseScroll wheel', function(e) {
    if ($(window).width() > 768) {
      var e0 = e.originalEvent,
        delta = e0.wheelDelta || -e0.detail;
      this.scrollTop += (delta < 0 ? 1 : -1) * 30;
      e.preventDefault();
    }
  });

  // Scroll to top button appear
  $(document).on('scroll', function() {
    var scrollDistance = $(this).scrollTop();
    if (scrollDistance > 100) {
      $('.scroll-to-top').fadeIn();
    } else {
      $('.scroll-to-top').fadeOut();
    }
  });

  // Smooth scrolling using jQuery easing
  $(document).on('click', 'a.scroll-to-top', function(e) {
    var $anchor = $(this);
    $('html, body').stop().animate({
      scrollTop: ($($anchor.attr('href')).offset().top)
    }, 1000, 'easeInOutExpo');
    e.preventDefault();
  });

  $('.navbar-nav .nav-item').on('click', function(){
    $('.navbar-nav .nav-item').removeClass('active');
    $(this).addClass('active');
})

  // $(document).on('ready', function() {
  //     $(".navbar-nav .nav-link").on("click", function(event) {
  //         event.preventDefault();
  //         var clickedItem = $( this );
  //         $(".navbar-nav .nav-link").each( function() {
  //             $( this ).removeClass( "active" );
  //         });
  //         clickedItem.addClass( "active" );
  //     });
  // });

})(jQuery); // End of use strict
