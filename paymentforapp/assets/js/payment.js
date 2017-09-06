var Payment = {}
var PaymentMegabank = {}
var SECRET = "6LdVAxkTAAAAAHBO45vG52ZMogoakzo4wopvuLke";

function reRenderCaptcha() {
  grecaptcha.reset();
}

$(function() {
	Payment.init();
	PaymentMegabank.init();
	$(".navigation-block").on('click', '.btn-back', function(event) {
		event.preventDefault();
		var href = $(this).siblings('.payment-method-box').attr('href');
		$(this).parents(".navigation-block").addClass('full');
		$(this).parent().removeClass('active');
		$(href).collapse('hide');
		if (href == '#sms') $('.payment-block').find('.fisrt-mobifone').removeClass('hidden');
		// $(".promo-block").collapse('show');

	});
	$(".navigation-block").on('click', '.payment-method-box', function(event) {
		event.preventDefault();
		if (!$(this).parents("li").hasClass('disabled')) {
			var href = $(this).attr('href');
			if (href == '#sms') $('.payment-block').find('.fisrt-mobifone').addClass('hidden');
			if (!$(this).parent().hasClass('active')) {
				$(this).parent().addClass('active');
				$(href).collapse('show');
				// $(".promo-block").collapse('hide');
				$(this).parents(".navigation-block").removeClass('full');
			} else {
				return;
			}
		} else {
			return;
		}
	});
	$(".item-info-block").find('.box').on('click', 'a.box-wrapper', function(event) {
		event.preventDefault();
		var stepBox = $(this).parents(".step-content-box");
		$(this).parent().find('a.box-wrapper').removeClass('active');
		$(this).addClass('active');
		stepBox.removeClass("active").addClass("unactive").siblings('.step-content-box').addClass('active');
		$(this).parents(".content-box").find('.step-block li.active').next('li').addClass('active');
	});


	$(".step-block").on('click', 'a', function(event) {
		event.preventDefault();
		var parent = $(this).parent();
		var href = $(this).attr('href');

		if (parent.next().hasClass('active')) {
			parent.addClass("active");
			parent.next().removeClass("active");
			$(href).find('a.box-wrapper').removeClass('active');
			$(href).removeClass('unactive').addClass('active');
			$(href).next().removeClass('active');
		}
	});
});

PaymentMegabank.init = function(){
	scope = this;
	scope.handlePaymentMegabank();
	scope.handlePaymentSmsMbpVnp();
	scope.handlePaymentSmsMbp();
	scope.handlePaymentSmsVt();
	scope.handleRedeemCode();
}

PaymentMegabank.handlePaymentMegabank = function(){
	$('.btn-PaymentMegabank').one('click', '.btn-primary', function(event) {
		event.preventDefault();
		var key_megabank = grecaptcha.getResponse(widgetMegabank);
		var megabank_id	= parseInt($('#internet_Banking .box-wrapper.active').attr('data-value'));
		var bank_id	= $('#internet_Banking .form-block .input-group [name="bank"]').val();
		var respUrl = window.location.origin+"/payment/result";
		if((typeof token === 'undefined' || token == '') && window.location.search == ''){
			$('.btn-signin').trigger("click");
		} else {
			if(key_megabank !== '' && megabank_id !== '' && bank_id !== '' && respUrl !== ''){
				token = window.location.search != '' ? window.location.search.split("token=")[1] : token;
				var data = {megabank_id: megabank_id, bank_id: bank_id, respUrl: respUrl, key_megabank: key_megabank};
				$.ajax({
					url: API_PATH + 'users/internet-banking',
					method: "POST",
					headers: { 'Authorization': 'Token token=' + token},
					dataType: 'json',
					data: data,
					beforeSend: function () {
						$('.form-block .btn.btn-payment').addClass('loading');
					},
					statusCode: {
						200: function(data){
						  console.log('PaymentMegabank.handlePaymentMegabank');
              console.log('data=', JSON.stringify(data));
							window.location = data.url
						},
						400: function(data){
							var msg = JSON.parse(data.responseText);
							PModal.modalAlert(msg.error, function(){
								$('.btn-PaymentMegabank').removeClass('loading');
							});
						},
						500: function(data){
							PModal.modalAlert(data.responseText, function(){
								$('.btn-PaymentMegabank').removeClass('loading');
							});
						}
					}
				});
			} else {
				PModal.modalAlert("Vui lòng điền đầy đủ thông tin !!!", function(){
					$('.btn-payment').removeClass('loading');
				});
			}
		}
	});
}

PaymentMegabank.handlePaymentSmsMbpVnp = function(){
	$('#mbp-vnp').on('click', '.box', function(event) {
		event.preventDefault();
		var price = parseInt($(this).attr("data-price").replace(/\./gi, ""));
		var coin = $(this).attr("data-coin");
		var name = $(this).attr("data-name");
		var code = $('#sms').attr("data-code");
		PModal.modalSmsMbpVnp(code, name, price/1000, coin, function(){
		});
	});
}

//Mobifone
PaymentMegabank.handlePaymentSmsMbp = function(){
	$('.mbp').on('click', '.box', function(event) {
		event.preventDefault();
		var price = $(this).attr("data-price");
		var coin = $(this).attr("data-coin");
		var name = $(this).attr("data-name");
		var code = $('#sms').attr("data-code");
		PModal.modalSmsMbp(code, name, price, coin, function(){});
	});
}


PaymentMegabank.handlePaymentSmsVt = function(){
	$('#vt').on('click', '.box', function(event) {
		event.preventDefault();
		var price = parseInt($(this).attr("data-price").replace(/\./gi, ""));
		var coin = $(this).attr("data-coin");
		var name = $(this).attr("data-name");
		var code = $('#sms').attr("data-code");
		PModal.modalSmsVt(code, name, price, coin, function(){
		});
	});
}

Payment.loadPaymentMegabank = function(megabank_id, bank_id, respUrl){
	scope = this;
	var data = {megabank_id: megabank_id, bank_id: bank_id, respUrl: respUrl};
	$.ajax({
		url: API_PATH + 'users/internet-banking',
		method: "POST",
		headers: { 'Authorization': 'Token token="' + token + '"'},
		dataType: 'json',
		data: data,
		beforeSend: function () {
			$('.btn-payment').addClass('loading');
	    },
	    statusCode: {
			200: function(data){
			  console.log('Payment.loadPaymentMegabank');
			  console.log('data=', JSON.stringify(data));
				window.location = data.url
			},
			400: function(data){
				PModal.modalAlert(data.responseText, function(){
					$('.btn-PaymentMegabank').removeClass('loading');
				});
			},
			500: function(data){
				PModal.modalAlert(data.responseText, function(){
					$('.btn-PaymentMegabank').removeClass('loading');
				});
			}
		}
	});
}

Payment.init = function(){
	scope = this;
	scope.handleCard();
}

Payment.handleCard = function(){
	$('#btn-payment-by-card').on('click', function(event) {
		event.preventDefault();
    if(!token || typeof (token) === 'undefined' || token == '')
    {
      PModal.modalAlert("Vui lòng đăng nhập !", function()
      {
        $('#btn-payment-by-card').removeClass('loading');
        $('.btn-signin').trigger("click");
      });
      return;
    }
		var key_payment = grecaptcha.getResponse(widgetCard);
		var provider 	= $('.form-block .input-group [name="provider"]').val();
		var pin 		= $('.form-block .input-group input[name="pin"]').val();
		var serial 		= $('.form-block .input-group input[name="serial"]').val();
    if(!key_payment || !provider || !pin || !serial)
    {
      PModal.modalAlert("Vui lòng điền đầy đủ thông tin !!!", function(){
        $('#btn-payment-by-card').removeClass('loading');
      });
      return;
    }
		if((typeof (token) === 'undefined' || token == '') && window.location.search == ''){
			$('.btn-signin').trigger("click");
		} else{
			if(key_payment !== '' && provider !== '' && pin !== '' && serial !== ''){
				token = window.location.search != '' ? window.location.search.split("token=")[1] : token;
				var data = {provider: provider, pin: pin, serial: serial, key_payment: key_payment};
				$.ajax({
					url: API_PATH + 'users/mega-card',
					method: "POST",
					headers: { 'Authorization': 'Token token=' + token},
					dataType: 'json',
					data: data,
					beforeSend: function () {
						$('#btn-payment-by-card').addClass('loading');
					},
					statusCode: {
						200: function(data){
              console.log(data);
              $('#btn-payment-by-card').removeClass('loading');
              var msg = (data.responseJSON ? data.responseJSON.message : '') || 'Nạp tiền thành công.';
							PModal.modalAlert(msg, function(){
								window.location.reload(); // = window.location.pathname
							});
						},
						400: function(data){
              $('#btn-payment-by-card').removeClass('loading');
              reRenderCaptcha();
						  console.log(data);
              var msg = (data.responseJSON ? data.responseJSON.message : '') || "Thẻ cào bị lỗi, vui lòng thử lại sau";
							PModal.modalAlert(msg, function(){
                $('#btn-payment-by-card').removeClass('loading');
							});
						},
						401: function(data){
              $('#btn-payment-by-card').removeClass('loading');
              reRenderCaptcha();
              console.log(data);
              var msg = (data.responseJSON ? data.responseJSON.message : '') || "Thẻ cào bị lỗi, vui lòng thử lại sau";
              PModal.modalAlert(msg, function(){
                $('#btn-payment-by-card').removeClass('loading');
              });
						},
            403: function(data){
              console.log(data);
              reRenderCaptcha();
              var msg = (data.responseJSON ? data.responseJSON.message : '') || "Thẻ cào bị lỗi, vui lòng thử lại sau";
              PModal.modalAlert(msg, function(){
                $('#btn-payment-by-card').removeClass('loading');
              });
            },
            500: function(data)
            {
              console.log(data);
              $('#btn-payment-by-card').removeClass('loading');
              reRenderCaptcha();
              var msg = (data.responseJSON ? data.responseJSON.message : '') || "Thẻ cào bị lỗi, vui lòng thử lại sau";
                PModal.modalAlert(msg, function(){});
            }
					}
				}).done(function (data)
        {
          console.log(data);
          $('#btn-payment-by-card').removeClass('loading');
        });
			} else{
				PModal.modalAlert("Vui lòng điền đầy đủ thông tin !!!", function(){
          $('#btn-payment-by-card').removeClass('loading');
				});
			}
		}
	});
};

Payment.loadCard = function(provider, pin, serial)
{
	scope = this;
  if(!provider || !pin || !serial)
    return $.notify('Vui lòng điền đầy đủ thông tin.');
	var data = {provider: provider, pin: pin, serial: serial};
	$.ajax({
		url: API_PATH + 'users/mega-card',
		method: "POST",
		headers: { 'Authorization': 'Token token=' + token },
		dataType: 'json',
		data: data,
		beforeSend: function () {
			  $('.btn-payment').addClass('loading');
    },
    statusCode: {
			200: function(data){
        console.log(data);
				PModal.modalAlert(data.responseText, function(){
					window.location = window.location.pathname
				});
			},
      201: function(data){
        console.log(data);
      },
      401: function(data){
        console.log(data);
      },
      403: function(data){
        console.log(data);
      },
      404: function(data){
        console.log(data);
      },
			400: function(data){
        console.log(data);
				PModal.modalAlert(data.responseText, function(){
					$('.btn-payment').removeClass('loading');
				});
			},
			500: function(data){
        console.log(data);
				PModal.modalAlert(data.responseText, function(){
					$('.btn-payment').removeClass('loading');
				});
			}
		}
	}).done(function (data) {
	  console.log(data);
    $('.btn-payment').removeClass('loading');
  });
};

PaymentMegabank.handleRedeemCode = function(){
	$('#redeem_Code').on('click', '.btn-redeem', function(event) {
		event.preventDefault();
		var redeemcode = $('#redeemCode').val();
    if(!redeemcode || redeemcode=='')
      return $.notify('Vui lòng nhập vào mã code');
		var data = {code: redeemcode};
		$(this).addClass('loading');
		$.ajax({
			url: API_PATH + 'users/redeem',
			method: "POST",
			headers: { 'Authorization': 'Token token=' + token},
			dataType: 'json',
			data: data,
      statusCode: {
				200: function(data){
          console.log(data);
					$('.btn-redeem').removeClass('loading');
					$.notify(data.message);
					setTimeout(function(){
						window.location = window.location.pathname
					}, 3000);
				},
        401: function(data){
				  console.log(data);
          $('.btn-redeem').removeClass('loading');
        },
        403: function(data){
          console.log(data);
          $('.btn-redeem').removeClass('loading');
        },
				400: function(data){
					$('.btn-redeem').removeClass('loading');
					$.notify(jQuery.parseJSON(data.responseText).error);
					setTimeout(function(){
						window.location = window.location.pathname
					}, 3000);
				},
				500: function(data){
          $('.btn-redeem').removeClass('loading');
					PModal.modalAlert(data.responseText, function(){
					});
				}
			}
		}).done(function (data) {
      $('.btn-redeem').removeClass('loading');
      console.log('handleRedeemCode=',data);
    });
	});
};