$(function() {
	Rank.init();
	Liveshow.init();
	function idolBoxAnimation(sel) {
		var timeout;
		if (timeout) {
			clearTimeout(timeout);
		}
		sel.each(function(index, e){ 
			var selector = $(this);
			selector.addClass('invisible');
		    timeout = setTimeout(function() {
		    	selector
		    		.removeClass('invisible')
		    		.addClass('animated fadeInUp')
		    		.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
		    			$(this).removeClass('animated fadeInUp');
			    	});
			}, index * 250);
		});
	}
	function buttonAnimation(selector, animationName, delayTime) {
		var animationClass = 'animated ' + animationName, timeout;
		if (timeout) {
			clearTimeout(timeout);
		}
		selector.addClass('invisible');
		timeout = setTimeout(function() {
			selector
				.removeClass('invisible')
				.addClass(animationClass)
				.one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
	    			$(this).removeClass(animationClass);
	    		});
		}, delayTime);
	}
	$(window).on('load', function(event) {
		// idolBoxAnimation($(".idols-on-air-upcoming-block, .idols-on-air-block").find('.idol-box'));
		// buttonAnimation($(".idols-on-air-upcoming-block, .idols-on-air-block").find(".btn-see-more"), "zoomIn", 1000);
		$(".idols-on-air-upcoming-block").find('.nav li').each(function(index, el) {
			$(this).find('a[role="tab"]').on('click', function(event) {
				event.preventDefault();
				var box = $(this).parents(".wrapper").find('.idol-box');
				var id = $(this).attr("href");
				var selector = $(this).parents(".wrapper").find(id);
				var removeButton = selector.find(".btn-see-more");
				// if (removeButton.length != 0) {
				// 	buttonAnimation(removeButton, "zoomIn", 1000);
				// }
				// box.removeClass('animated fadeInUp');
				// idolBoxAnimation(selector.find('.idol-box'));
			});
		});
	});

	$(".event-slider-side-block .slider-group").find('.inner').slick({
		infinite: true,
		slidesToShow: 1,
		slidesToScroll: 1,
		arrows: false,
		dots: true,
		variableWidth: false,
		autoplay: true, 
		autoplaySpeed: 3000
		// asNavFor: $(".top-block .slider-thumbnail").find('.inner')
	});

	

	// $('button.btn-signin[data-target="#modal_Signin"]').on('click', function(event) {
	// 	$("#frm-login").attr("action","/login");
	// });

	//show login 
	var login_id = window.location.hash;
	var segment = login_id.split('?');
	if(segment[0] === "#login"){
		if(segment[1] != undefined){
			$("#frm-login").attr("action","/login?url="+segment[1]);
		}else{
			$("#frm-login").attr("action","/login");
		}
       	$("#modal_Signin").modal('show');
    }else if(segment[0] === "#signup"){
    	$("#modal_Signup").modal('show');
    }

	$('#modal_Signin').on('click', ".btn-signup", function(){
		$("#modal_Signin").modal('hide')
		$("#modal_Signup").modal('show');
	});

	$('#modal_Signup').on('click', ".btn-signin", function(){
		$("#modal_Signup").modal('hide')
		$("#modal_Signin").modal('show');
	});

	$('#modal_Signin, #modal_Signup').on('click', '.btn-mobifone', function(){
		$("#modal_Signin, #modal_Signup").modal('hide')
		$("#modal_Mobifone").modal('show');
	});

	$('#modal_Mobifone').on('click', '.btn-access', function(){
		$("#modal_Signup, #modal_Mobifone").modal('hide')
		$("#modal_Signin").modal('show');
	});

	$('#modal_ResetPassword').on('click', '.btn-signin', function(){
		$("#modal_ResetPassword").modal('hide')
		$("#modal_Signin").modal('show');
	});

	$("#modal_Signin").on('click', '.btn-forgot-password', function(e){
		$("#modal_Signin").modal('hide')
		$("#modal_ResetPassword").modal('show');
	});

	//forgot password
	$("#modal_ResetPassword").on('click', '.btn-forgot', function(event)
  {
		event.preventDefault();
		var button 		= $(this);
		var email 		= $("#email-forgot").val();
		var regexMail 	= /[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}/igm;
    if(email=='')
    {
      console.log('khong co email=',email);
      return $("#modal_ResetPassword .form-group.email").find(".form-invalid-message").text('Vui lòng nhập vào email!');
    }
		if(regexMail.test(email)==false)
    {
      console.log('Email không đúng định dạng !', email);
      return $("#modal_ResetPassword .form-group.email").find(".form-invalid-message").text('Email không đúng định dạng !');
    }
    button.addClass('loading');
    $.ajax({ url: API_PATH+'auth/update-forgot-code', method: 'POST', data: {email: email},
      statusCode:
      {
        400: function (data) {
          console.log(data);
          button.removeClass('loading');
          var msg = (data.responseJSON && data.responseJSON.message)?data.responseJSON.message : data.message;
          $("#modal_ResetPassword .form-group.email").find(".form-invalid-message").text(msg);
        },
        200: function (data) {
          console.log(data);
          button.removeClass('loading');
          var msg = (data.responseJSON && data.responseJSON.message)?data.responseJSON.message : data.message;
          $("#modal_ResetPassword .form-group.email").find(".form-invalid-message").text(msg);
        }
      }
    }).done(function (data)
    {
      console.log(data);
      button.removeClass('loading');
    });
	});

	//follow idol
	$('.container').on("click", ".idol-follow", function(event) {
		event.preventDefault();
		var target = $(event.target);

		if (typeof token == 'undefined' || token == '') {
			var timeOut;
			$("#searchResult").removeClass('open');
			clearTimeout(timeOut);
			timeOut = setTimeout(function() {
				$("#searchResult").hide();
			}, 500)

			$('.btn-signin').trigger("click");
		} else{
			var broadcaster_id = target.attr('data-id');
			if (typeof broadcaster_id == 'undefined' || broadcaster_id == '') return false;

			$.ajax({
				url: API_PATH + 'broadcasters/' + broadcaster_id + '/follow',
				contentType: 'application/json',
				dataType: 'json',
				headers: {'Authorization': 'Token token=' + token},
				method: 'PUT',
				statusCode: {
					401: function () {
						$('.btn-signin').trigger("click");
					},
					200: function () {
						target.html('Theo dõi');
					},
					201: function () {
						target.html('Đang theo dõi');
					}
				}
			});
		}
	});
});

