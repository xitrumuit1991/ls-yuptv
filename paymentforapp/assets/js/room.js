autosize($("textarea"));
$(function() {
	$("#modal_Lockscreen").modal({
	    backdrop: 'static',
	    keyboard: false,
	    show: false
	});
	// clear event handle of yes btn
	$('#modal_Livestar').on('hidden.bs.modal', function () {
		$('#modal_livestar_btn_yes').off('click');
	});

	var $screenTextAnimation = $(".screen-text-block").marquee({
		duration: 15000,
		gap: 50,
		delayBeforeStart: 0,
		direction: 'left',
		duplicated: false
	});

	$(".screen-text-block").on({
		mouseenter: function(e) {
			$screenTextAnimation.marquee('pause');
		},
		mouseleave: function(e) {
			$screenTextAnimation.marquee('resume');
		}
	});
	$(".showtime-group, .action-group, .gift-group, #user_List").find(".inner").mCustomScrollbar({
		axis: "y",
		scrollInertia: 0
	});

	// $(".idol-chat-content-group, .user-chat-content-group").find('.chat-wrapper').mCustomScrollbar({
	$(".user-chat-content-group").find('.chat-wrapper').mCustomScrollbar({
		axis: "y",
		scrollInertia: 0,
		callbacks:{
			onInit: function() {
				$(this).mCustomScrollbar("scrollTo","bottom",{
					scrollInertia: 0
				});
			},
			onScroll: function() {
				topPct = this.mcs.topPct;
			}
		}
	});

	$(".profile-block").find('.wrapper').mCustomScrollbar({
		axis: "y",
		scrollInertia: 0
	});


	// $("body").append('<div class="gift-block-select-group"></div>');
	// $(".gift-block").find("select").select2({
	// 	minimumResultsForSearch: Infinity,
	// 	dropdownParent: $(".gift-block-select-group")
	// });

	// $(".button-control-group").on('click', '.btn-control', function(event) {
	// 	event.preventDefault();
	// });

	$(".other-idols-block .idol-group").find('.inner').slick({
		infinite: true,
		slidesToShow: 4,
		slidesToScroll: 1,
		arrows: true,
		variableWidth: false,
		prevArrow: $(".other-idols-block .button-control-group").find('.prev'),
		nextArrow: $(".other-idols-block .button-control-group").find('.next'),
		responsive: [
		{
			breakpoint: 9999,
			settings: {
				slidesToShow: 4,
				slidesToScroll: 1
			}
		},
		{
			breakpoint: 992,
			settings: {
				slidesToShow: 3,
				slidesToScroll: 1
			}
		},
		{
			breakpoint: 768,
			settings: {
				slidesToShow: 2,
				slidesToScroll: 1
			}
		},
		{
			breakpoint: 480,
			settings: {
				slidesToShow: 1,
				slidesToScroll: 1
			}
		}]
	});

	$(".profile-block .video-group").find('.group-inner').slick({
		infinite: true,
		slidesToShow: 3,
		slidesToScroll: 1,
		arrows: true,
		variableWidth: false,
		prevArrow: $(".profile-block .video-block .button-control-group").find('.prev'),
		nextArrow: $(".profile-block .video-block .button-control-group").find('.next')
	});

	$(".profile-block .image-group").find('.group-inner').slick({
		infinite: true,
		slidesToShow: 3,
		slidesToScroll: 1,
		arrows: true,
		variableWidth: false,
		prevArrow: $(".profile-block .image-block .button-control-group").find('.prev'),
		nextArrow: $(".profile-block .image-block .button-control-group").find('.next')
	})

	$(".profile-block").find('.group-inner').one('mouseenter', 'a', function(event) {
		$('.profile-block .image-group').find('.group-inner').lightGallery({
			selector: "a",
			download: false
		});
		$('.profile-block .video-group').find('.group-inner').lightGallery({
			selector: "a",
			download: false,
			videojs: true,
			videojsOptions: {
				hls: {
					withCredentials: true
				}
			}
		});
	});

	var placeholder = $('.input-message-block').find('textarea').attr("placeholder");
	$('.input-message-block').find('textarea').on("blur", function(event) {
		if ($(this).val().length == 0){
			$(this).siblings().text(placeholder);
		}else{
			return;
		}
	});

	$(".btn-toggle-profile").on('click', function(event) {
		event.preventDefault();
		$(this).parent().toggleClass('open');
	});
	$('#room .left-block .image-block').find('a').on('click', function(event) {
		event.preventDefault();
		$(".btn-toggle-profile").parent().toggleClass('open');
	});
	$('#room .left-block .idol-name-block').find('a').on('click', function(event) {
		event.preventDefault();
		$(".btn-toggle-profile").parent().toggleClass('open');
	});
	//Tooltip code AREA
	function tooltip_Template(name, coin, vote) {
		var html = '<div class="room-tooltip">'
		html += '<h4>'+ name +'</h4>'
		html += '<p>Giá: '+ coin +' xu/lượt</p>'
		if (vote !== undefined) {
			html += '<p>Hiện có '+ vote +' lượt bình chọn</p>';
		}
		html += '</div>'
		return html;
	}

	function add_Tooltip(selector) {
		var data_Tooltip, name, coin, vote, top, left, width;
		width = selector.width()*2.5;
		top = selector.parent().offset().top + selector.height() + 7;
		left = selector.parent().offset().left - (width/3.5);
		name = selector.attr('data-name');
		coin = selector.attr('data-coin');
		vote = typeof vote !== undefined ? selector.attr('data-vote') : null;
		data_Tooltip = tooltip_Template(name, coin, vote);
		$("body").append(data_Tooltip);
		$(".room-tooltip").css({
			width: width,
			top: top,
			left: left,
		});
	}

	$(".action-group").on({
		mouseenter: function(e) {
			add_Tooltip($(this));
		},
		mouseleave: function(e) {
			$(".room-tooltip").remove();
		}
	}, '.action-box a');

	$(".gift-group").on({
		mouseenter: function(e) {
			add_Tooltip($(this));
		},
		mouseleave: function(e) {
			$(".room-tooltip").remove();
		},
		click: function(e) {
			$(this).parents(".gift-block").addClass('selected-item');
		}
	}, '.gift-box label');


	//End of Tooltip code

	$('.follow-block').on("click", ".btn-follow", function(event){
		event.preventDefault();
    if(!user || typeof(user)== 'undefined' || user==undefined)
    {
      $('.btn-signin').trigger("click");
      return;
    }
		$.ajax({
			url: API_PATH + 'broadcasters/'+room.broadcaster.broadcaster_id+'/follow',
			contentType: 'application/json',
			dataType: 'json',
			headers: { 'Authorization': 'Token token="' + token + '"'},
			method: 'PUT',
			statusCode: {
				401: function(){
					// window.location = 'http://' + window.location.host + '/logout';
					$('.btn-signin').trigger("click");
				},
				200: function(){
					$('.btn-follow').html('Theo dõi');
					$(this).parents(".follow-block").removeClass('followed');
				},
				201: function(){
					$('.btn-follow').html('Đang theo dõi');
					$(this).parents(".follow-block").addClass('followed');
				}
			}
		});
	});

	// New code here
	function hide_screenText() {
		if ($(".screen-text-block").find('.message').length == 0) {
			var screenText_Time = setTimeout(function() {
				$(".screen-text-block").addClass('hidden');
			}, 20000);
		} else {
			return;
		}
	}

	// Split idol and user chat content
	// var min = 50;
	// var max = $(".chat-content-block").height() - min;
	// $(".chat-content-block").find(".btn-split-chat-content").css({"top": max});
	// $(".chat-content-block").find(".user-chat-content-group").css({"height": max});
	// $(".chat-content-block").find(".idol-chat-content-group").css({"height": min});
	// $(".chat-content-block").find(".btn-split-chat-content").on("vmousedown", function(e) {
	// 	e.preventDefault();
	// 	$(document).on("vmousemove", function (e) {
	// 		e.preventDefault();
	// 		var userY, idolY;
	// 		userY = e.pageY - $(".chat-content-block").find('.user-chat-content-group').offset().top;
	// 		idolY = $(".chat-content-block").height() - userY;
	// 		if (userY < min) {
	// 			userY = min;
	// 		} else if (userY >= max) {
	// 			userY = max;
	// 		}
	// 		$(".chat-content-block").find(".btn-split-chat-content").css({"top": userY});
	// 		$(".chat-content-block").find(".user-chat-content-group").css({"height": userY});
	// 		$(".chat-content-block").find(".idol-chat-content-group").css({"height": idolY});
	// 	});
	// }).on("click", function() {
	// 	event.preventDefault();
	// });
	Featured.follow_idol();
	RankInRoom.init();
	RoomSidebar.loadFullBroadcasterProfile();

	$(document).mouseup(function (e) {
	    $(document).off('mousemove');
	});

	// background of room <Anco>
	var room_background = room.background;
	if(room_background != false){
		$('.main#room').css('background-image', 'url(' + API_DOMAIN + room_background + ')');
	}

	// Emoji
	var people =["😀","😬","😁","😂","😃","😄","😅","😆","😇","😉","😊","🙂","🙃","☺️","😋","😌","😍","😘","😗","😙","😚","😜","😝","😛","🤑","🤓","😎","🤗","😏","😶","😐","😑","😒","🙄","🤔","😳","😞","😟","😠","😡","😔","😕","🙁","☹️","😣","😖","😫","😩","😤","😮","😱","😨","😰","😯","😦","😧","😢","😥","😪","😓","😭","😵","😲","🤐","😷","🤒","🤕","😴","💤","💩","😈","👿","👹","👺","💀","👻","👽","🤖","🙌","👏","👋","👍","👊","✊","✌️","👌","✋","💪","🙏","☝️","👆","👇","👈","👉","🖕","🤘","🖖","✍️","💅","👄","👅","👂","👃","👁","👀","👤","🗣"];
	var items =["👚","👕","👖","👔","👗","👙","👘","💄","💋","👣","👠","👡","👢","👞","👟","👒","🎩","⛑","🎓","👑","🎒","👝","👛","👜","💼","👓","🕶","💍","🌂","⌚️","📱","📲","💻","⌨","🖥","🖨","🖱","🖲","🕹","🗜","💽","💾","💿","📀","📼","📷","📸","📹","🎥","📽","🎞","📞","☎️","📟","📠","📺","📻","🎙","🎚","🎛","⏱","⏲","⏰","🕰","⏳","⌛️","📡","🔋","🔌","💡","🔦","🕯","🗑","🛢","💸","💵","💴","💶","💷","💰","💳","💎","⚖","🔧","🔨","⚒","🛠","⛏","🔩","⚙","⛓","🔫","💣","🔪","🗡","⚔","🛡","🚬","☠","⚰","⚱","🏺","🔮","📿","💈","⚗","🔭","🔬","🕳","💊","💉","🌡","🏷","🔖","🚽","🚿","🛁","🔑","🗝","🛋","🛌","🛏","🚪","🛎","🖼","🗺","⛱","🗿","🛍","🎈","🎏","🎀","🎁","🎊","🎉","🎎","🎐","🎌","🏮","✉️","📩","📨","📧","💌","📮","📪","📫","📬","📭","📦","📯","📥","📤","📜","📃","📑","📊","📈","📉","📄","📅","📆","🗓","📇","🗃","🗳","🗄","📋","🗒","📁","📂","🗂","🗞","📰","📓","📕","📗","📘","📙","📔","📒","📚","📖","🔗","📎","🖇","✂️","📐","📏","📌","📍","🚩","🏳","🏴","🔐","🔒","🔓","🔏","🖊","🖊","🖋","✒️","📝","✏️","🖍","🖌","🔍","🔎"];
	var nature =["🐶","🐱","🐭","🐹","🐰","🐻","🐼","🐨","🐯","🦁","🐮","🐷","🐽","🐸","🐙","🐵","🙈","🙉","🙊","🐒","🐔","🐧","🐦","🐤","🐣","🐥","🐺","🐗","🐴","🦄","🐝","🐛","🐌","🐞","🐜","🕷","🦂","🦀","🐍","🐢","🐠","🐟","🐡","🐬","🐳","🐋","🐊","🐆","🐅","🐃","🐂","🐄","🐪","🐫","🐘","🐐","🐏","🐑","🐎","🐖","🐀","🐁","🐓","🦃","🕊","🐕","🐩","🐈","🐇","🐿","🐾","🐉","🐲","🌵","🎄","🌲","🌳","🌴","🌱","🌿","☘","🍀","🎍","🎋","🍃","🍂","🍁","🌾","🌺","🌻","🌹","🌷","🌼","🌸","💐","🍄","🌰","🎃","🐚","🕸","🌎","🌍","🌏","🌕","🌖","🌗","🌘","🌑","🌒","🌓","🌔","🌚","🌝","🌛","🌜","🌞","🌙","⭐️","🌟","💫","✨","☄","☀️","🌤","⛅️","🌥","🌦","☁️","🌧","⛈","🌩","⚡️","🔥","💥","❄️","🌨","🔥","💥","❄️","🌨","☃️","⛄️","🌬","💨","🌪","🌫","☂️","☔️","💧","💦","🌊"];
	var food =["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍈","🍒","🍑","🍍","🍅","🍆","🌶","🌽","🍠","🍯","🍞","🧀","🍗","🍖","🍤","🍳","🍔","🍟","🌭","🍕","🍝","🌮","🌯","🍜","🍲","🍥","🍣","🍱","🍛","🍙","🍚","🍘","🍢","🍡","🍧","🍨","🍦","🍰","🎂","🍮","🍬","🍭","🍫","🍿","🍩","🍪","🍺","🍻","🍷","🍸","🍹","🍾","🍶","🍵","☕️","🍼","🍴","🍽"];
	var activity =["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🎱","⛳️","🏌","🏓","🏸","🏒","🏑","🏏","🎿","⛷","🏂","⛸","🏹","🎣","🚣","🏊","🏄","🛀","⛹","🏋","🚴","🚵","🏇","🕴","🏆","🎽","🏅","🎖","🎗","🏵","🎫","🎟","🎭","🎨","🎪","🎤","🎧","🎼","🎹","🎷","🎺","🎸","🎻","🎬","🎮","👾","🎯","🎲","🎰","🎳" ];
	var travel =["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑","🚒","🚐","🚚","🚛","🚜","🏍","🚲","🚨","🚔","🚍","🚘","🚖","🚡","🚠","🚟","🚃","🚋","🚝","🚄","🚅","🚈","🚞","🚂","🚆","🚇","🚊","🚉","🚁","🛩","✈️","🛫","🛬","⛵️","🛥","🚤","⛴","🛳","🚀","🛰","💺","⚓️","🚧","⛽️","🚏","🚦","🚥","🏁","🚢","🎡","🎢","🎠","🏗","🌁","🗼","🏭","⛲️","🎑","⛰","🏔","🗻","🌋","🗾","🏕","⛺️","🏞","🛣","🛤","🌅","🌄","🏜","🏖","🏝","🌇","🌆","🏙","🌃","🌉","🌌","🌠","🎇","🎆","🌈","🏘","🏰","🏯","🏟","🗽","🏠","🏡","🏚","🏢","🏬","🏣","🏤","🏥","🏦","🏨","🏪","🏫","🏩","💒","🏛","⛪️","🕌","🕍","🕋","⛩"];

	function addlink_Emoji(emojiList) {
		var html = [];
		for (i=0; i<emojiList.length; i++) {
			html.push('<a href="#">'+emojiList[i]+'</a>');
		}
		return html;
	}

	var all_emoji = [people, items, nature, food, activity, travel];
	$.each(all_emoji, function(i, el) {
		$('#emoji_List_'+(i+1)+'').find('.inner').append(addlink_Emoji(el));
	});
	$("body").append('');

	var top, left, $menu = $(".emoji-block");
	var emoji = {
		position: function(event) {
			top = $('.input-message-block').offset().top;
			left = $('.input-message-block').offset().left;
			$menu.css({
				top: top - $menu.height(),
				left: left
			});
		},
		// navScrollbar: function(event) {
		// 	$menu.find(".nav-block").mCustomScrollbar({
		// 		axis: "x",
		// 		scrollInertia: 0,
		// 		autoExpandScrollbar: true,
		// 		advanced:{ autoExpandHorizontalScroll: true }
		// 	});
		// },
		contentScrollbar: function(event) {
			$menu.find(".inner").mCustomScrollbar({
				axis: "y",
				scrollInertia: 0,
				autoExpandScrollbar: true,
			});
		}
	}
	$(".btn-emoticon").on('click', function(event) {
		event.stopPropagation();
		$(this).toggleClass('active');
		if($(this).hasClass('active')) {
			emoji.position();
			// emoji.navScrollbar();
			emoji.contentScrollbar();
			$menu.show();
			$("html").on('click', function(e) {
				if (!$menu.is(e.target) && $menu.has(e.target).length == 0){
					$(".btn-emoticon").removeClass('active');
					$menu.hide();
					$(this).off("click");
				}
			});
		} else {
			$menu.hide();
		}
	});


	$menu.find('.tab-content').on('click', 'a', function(e) {
		event.preventDefault();
		var textMessage = $("#txtMessage");
		textMessage.val(textMessage.val()+" "+$(this).text());
		textMessage.css("font-style", "normal");
		if (e.shiftKey === true) {
			return true;
		} else {
			$(".btn-emoticon").trigger('click');
			return false;
		}
	});

	$(window).on('resize', function(event) {
		event.preventDefault();
		emoji.position();
	});

	// Click to refresh to get new 'ranking-dashboard-block'
	$(".ranking-dashboard-block").on('click', '.btn-refresh', function(event) {
		$(this).parent().addClass('loading')
	});

	$(".room-chair-box").on('click', '.user-status', function(event) {
		event.preventDefault();
		$(this).addClass('focus');
	});
	$(".room-chair-box").on('mouseleave', '.user-status', function(event) {
		event.preventDefault();
		$(this).removeClass('focus');
	});
});