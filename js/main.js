(function () {
  "use strict";

  // preloader
  $(window).on("load", function () {
    $(".loader").fadeOut("slow");
  });

  // smooth scroll
  $("a").on("click", function (event) {
    if (this.hash !== "") {
      event.preventDefault();

      var hash = this.hash;

      $("html, body").animate(
        {
          scrollTop: $(hash).offset().top - 50,
        },
        850
      );
    }
  });

  // magnific popup
  $(".gallery").each(function () {
    // the containers for all your galleries
    $(this).magnificPopup({
      delegate: ".popup-image", // the selector for portfolio item
      type: "image",
      gallery: {
        enabled: true,
      },
    });
  });

  // swiper slider
  $(document).ready(function () {
    var swiper = new Swiper(".mySwiper", {
      slidesPerView: 3,
      spaceBetween: 30,
      pagination: {
        el: ".swiper-pagination",
        clickable: true,
      },
      breakpoints: {
        0: {
          slidesPerView: 1,
        },
        768: {
          slidesPerView: 2,
        },
        780: {
          slidesPerView: 3,
        },
      },
    });
  });

  // navbar toggler icon
  $(document).on("click", ".navbar-toggler", function (e) {
    $(this).parent().siblings().find("i").removeClass("la-remove");
    $(this).find("i").toggleClass("la-remove");
  });

  // navbar on scroll
  $(window).on("scroll", function () {
    var onScroll = $(this).scrollTop();

    if (onScroll > 50) {
      $(".navbar").addClass("navbar-fixed");
    } else {
      $(".navbar").removeClass("navbar-fixed");
    }
  });
  // Initialize the counter animation when it enters the viewport
  // Function to check if an element is in the viewport
  function isInViewport(element) {
    var elementTop = $(element).offset().top;
    var elementBottom = elementTop + $(element).outerHeight();
    var viewportTop = $(window).scrollTop();
    var viewportBottom = viewportTop + $(window).height();

    return elementBottom > viewportTop && elementTop < viewportBottom;
  }
  // Scroll event to add class when element is in viewport
  $(window).on("scroll", function () {
    $(".count").each(function () {
      if (isInViewport(this) && !$(this).hasClass("visible")) {
        $(this).addClass("visible");
        countUpAnimation();
        $(this).addClass("counted"); // Add the class when the element is in the viewport
      }
    });
  });
  function countUpAnimation() {
    $(".count").each(function () {
      var $this = $(this),
        target = $this.data("target");

      $this.addClass("fade-in"); // Add fade-in effect

      $({ countNum: $this.text() }).animate(
        { countNum: target },
        {
          duration: 2000, // 2 seconds animation
          easing: "swing",
          step: function () {
            $this.text(Math.floor(this.countNum) / 1000 + "K");
          },
          complete: function () {
            $this.text(target / 1000 + "K"); // Ensure final value
          },
        }
      );
    });
  }

  // popup

  // Initialize Magnific Popup
  $(".popup-link").magnificPopup({
    type: "image", // It's an image type popup
    gallery: {
      enabled: true, // Enable gallery if you want to navigate through multiple images
    },
  });
  //script end
})();
