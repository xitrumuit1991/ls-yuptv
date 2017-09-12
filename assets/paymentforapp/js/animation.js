var anim = {};
var livestarLocation = window.location.pathname;
if (livestarLocation.indexOf("room") > -1) {
	anim.sendGift = {
		show: function() {},
		hide: function() {},
		generate: function() {
			var scope = this;
			$.ajax({
				url: '/assets/javascripts/animation/confetti.js',
				dataType: 'script',
				success: function() {
					confetti.generate("sendGiftBackground");
					var sendGift = $("#sendGift");
					var sendGiftImage = $("#sendGift").find('.image');
					var image = sendGiftImage.find('img');
					var moveForce = 30; // max popup movement in pixels
					var rotateForce = 20; // max popup rotation in deg
					var flag = true;
					TweenMax.to(sendGiftImage, 0, {scale: 0, opacity: 0});
					scope.hide = function() {
						TweenMax.to(sendGiftImage, 0.5, {scale: 0, opacity: 0});
						sendGift.fadeOut('400', function() {
							confetti.stop();
						});
					}
					scope.show = function(selector) {
						sendGift.fadeIn("400", function () {
							var img = selector.find('img');
							var imgPath = img.attr('src').replace("w50h50_", "");
							// var imgPath = "http://api.livestar.vn//uploads/gift/image/1/01.png"
							image.one("load", function(){
								confetti.start();
								confetti.resize();
								TweenMax.from($("#sendGiftBackground"), 1, {
									opacity: 0,
									ease: Power0.easeNone
								});
								TweenMax.to(sendGiftImage, 0.5, {scale: 1, opacity: 1});
								TweenMax.to(sendGiftImage, 1.5, {scale: 1.25, ease: Elastic.easeOut.config(1, 0.5)});
								TweenMax.to(sendGiftImage, 0.5, {scale: 1});
							}).attr('src', imgPath);
						});
					}
					$(document).on({
						keydown: function(e) {
							var code = e.keyCode || e.which;
							if (code == 27) {
								scope.hide();
							}
						}
					});
					$(window).on({
						mousemove: function(e) {
							e.preventDefault();
						    var docX = $(document).width();
						    var docY = $(document).height();
						    		
						    var moveX = (e.pageX - docX/2) / (docX/2) * -moveForce;
						    var moveY = (e.pageY - docY/2) / (docY/2) * -moveForce;
						    
						    var rotateY = (e.pageX / docX * rotateForce*3) - rotateForce;
						    var rotateX = -((e.pageY / docY * rotateForce*3) - rotateForce);
						    sendGiftImage
						        .css('left', moveX+'px')
						        .css('top', moveY+'px')
						        .css({"-webkit-transform": 'rotateX('+rotateX+'deg) rotateY('+rotateY+'deg)',
								"-moz-transform": 'rotateX('+rotateX+'deg) rotateY('+rotateY+'deg)',
								"-ms-transform": 'rotateX('+rotateX+'deg) rotateY('+rotateY+'deg)',
								"-o-transform": 'rotateX('+rotateX+'deg) rotateY('+rotateY+'deg)',
								"transform": 'rotateX('+rotateX+'deg) rotateY('+rotateY+'deg)'});
						}
					});
					$(".gift-block").on('click', '.btn-gift', function(event) {
						event.preventDefault();
						if (!$(sendGift).is(':visible')) {
							scope.show($(this));
						} else {
							scope.hide();
						}
					});
				}
			});
		}
	}
	anim.heartExplode = {
		show: function() {},
		generate: function() {
			var fps = 30 , // frame rate per second
		    totalFrames = 28 , // your Sprite animation frames counts
		    dur = (1/fps)*(totalFrames-1) , // tween duration
		    spriteWidth = 100 ; // width of your Sprite image

		    var tlHeart = new TimelineMax({paused: true});
			  tlHeart.to('.heart', dur,{repeat:0,backgroundPosition:spriteWidth+'%',ease:SteppedEase.config(totalFrames)});
		    scope.show = function() {
		    	tlHeart.restart();
		    };
		    $(document).on('click', '.counting-love-box', function(event) {
		    	event.preventDefault();
          console.log('--------------.counting-love-box click---------');
          console.log(scope);
          console.log('typeof (scope): ',typeof (scope));
          console.log('typeof (scope.show)= ',typeof (scope.show));
          if(typeof (scope.show)=='function')
		    	  scope.show();
		    });
		}
	}
}
anim.levelUp = {
	show: function() {},
	generate: function() {
		var scope = this;
		$.ajax({
			url: '/assets/javascripts/animation/levelup.js',
			dataType: 'script',
			success: function() {
				scope.show = function() {
					levelUp();
				}
			}
		});
	}
}