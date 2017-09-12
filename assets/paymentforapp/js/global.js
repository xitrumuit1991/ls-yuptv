$(function() {
	// Center 'Modal Bootstrap' on any screen.
	function centerModal() {
		$(this).css('display', 'block');
		var $dialog = $(this).find(".modal-dialog");
		var offset = ($(window).height() - $dialog.height()) / 2;
		// Center modal vertically in window
		$dialog.css("margin-top", offset);
	}
	// Reposition when a modal is shown
	$('.modal').on('show.bs.modal', centerModal);

	// Reposition when window is resized
	$(window).on("resize", function () {
		$('.modal:visible').each(centerModal);
	});
	/*=============== SEPARATE CODE LINE ===============*/

	$.notify.addStyle("livestar", {
		html: "<div><div class='notify-inner' data-notify-html></div></div>"
	});

	$.notify.addStyle("livestar-okay", {
		html: "<div>" +
				"<div class='notify-inner' data-notify-html>" +
				"</div>" +
				"<div class='notify-button-group'>" +
					"<button class='btn-primary btn-okay btn-rounded' data-notify-hide>Okay</button>" +
				"</div>" +
			"</div>"
	});
	$.notify.addStyle("livestar-confirm", {
		html: "<div>" +
				"<div class='notify-inner' data-notify-html>" +
				"</div>" +
				"<div class='notify-button-group'>" +
					"<button class='btn-primary btn-accept btn-rounded'>Accept</button>" +
					"<button class='btn-default btn-cancel btn-rounded' data-notify-hide>Cancel</button>" +
				"</div>" +
			"</div>"
	});

	$.notify.defaults({
		style: "livestar",
		autoHideDelay: 5000,
		arrowShow: false,
		globalPosition: 'top right',
		showAnimation: 'slideDown',
		showDuration: 400,
		hideDuration: 200,
		hideAnimation: 'slideUp'
	});

	$(document).on("click", ".btn-primary[data-notify-hide]", function(e) {
		e.preventDefault();
		$(this).trigger("notify-hide");
	});
	/*=============== SEPARATE CODE LINE ===============*/

	// $(".btn-show-search-form").on('click', function(event) {
	// 	event.preventDefault();
	// 	$(this).parent().toggleClass('open');
	// });
	// $(window).on('scroll', function(event) {
	// 	event.preventDefault();
	// 	var inputForm = $(".btn-show-search-form").parent().find(".input-group");
	// 	searchTrigger = inputForm.offset().top + inputForm.height();
	// 	if ($(window).scrollTop() > searchTrigger) {
	// 		if ($(".btn-show-search-content").parent().hasClass('open'))
	// 			$(".btn-show-search-content").parent().removeClass('open');
	// 		else 
	// 			return;
	// 	}
	// });

	$(".navigation-backdrop").on('click', function(event) {
		$(this).parent().find('.nav-toggle').trigger('click');
	});
	/*=============== SEPARATE CODE LINE ===============*/

	var ink, d, x, y;
	$(".btn-primary, .btn-default").on("click", function(e){
		if($(this).find(".ink").length == 0)
			$(this).prepend("<span class='ink'></span>");
			
		ink = $(this).find(".ink");
		ink.removeClass("animate");
		
		if(!ink.height() && !ink.width()) {
			d = Math.max($(this).outerWidth(), $(this).outerHeight());
			ink.css({height: d, width: d});
		}
		x = e.pageX - $(this).offset().left - ink.width()/2;
		y = e.pageY - $(this).offset().top - ink.height()/2;
		ink.css({top: y+'px', left: x+'px'}).addClass("animate");
	})
	/*=============== SEPARATE CODE LINE ===============*/
	var userLevel = "";
	function tooltip_Progress_template(level, exp) {
		var html = '<div class="user-progress-tooltip">'
		html += '<h4>Cấp: '+ level +'</h4>'
		html += '<p>Điểm kinh nghiệm: <br/>'+ exp +'</p>'
		html += '</div>'
		return html;
	}

	function add_Progress_Tooltip(selector, center) {
		var data_Tooltip, level, exp, top, left;
		width = $(".action-box a").width()*2.5 || 150;
		top = selector.offset().top + selector.height() + 10;
		if (center == true) {
			left = selector.offset().left - (width/9);
		} else {
			left = selector.offset().left - (width/3.5);
		}
		level = selector.attr('data-level');
		exp = selector.attr('data-exp');
		data_Tooltip = tooltip_Progress_template(level, exp);
		$("body").append(data_Tooltip);
		$(".user-progress-tooltip").css({
			width: width,
			top: top,
			left: left,
		});
	}

	$(".user-progress").on({
		mouseenter: function(e) {
			add_Progress_Tooltip($(this));
		},
		mouseleave: function(e) {
			$(".user-progress-tooltip").remove();
		}
	}); 

	$("#room .main-block .progress-block").on({
		mouseenter: function(e) {
			var top = $(this).offset().top + $(this).height() + 10;
			add_Progress_Tooltip($(this), true);
		},
		mouseleave: function(e) {
			$(".user-progress-tooltip").remove();
		}
	}); 
	/*=============== SEPARATE CODE LINE ===============*/
	var tooltip = (function() {
		var tooltipTemplate = function(heading, content, style, callback) {
			var tooltipHeading = heading || "",
				tooltipContent = content || "",
				tooltipStyle = "tooltip-" + style;
				tooltipTemplate = "";
			tooltipTemplate = ['<div class="tooltip '+tooltipStyle+'">',
				'<div class="tooltip-inner">',
					'<h5 class="tooltip-heading">',
						'<span class="text">'+tooltipHeading+'</span>',
					'</h5>',
					'<div class="tooltip-content">'+tooltipContent+'</div>',
				'</div>',
			'</div>'].join('');
			callback(tooltipTemplate);
		}
		var tooltipDisplay = function(self) {
			var emBase = self.find('.icon').width();
			var top = self.offset().top + emBase,
				left = self.find('.icon').offset().left - (emBase/2),
				heading = self.attr("data-heading"),
				content = self.attr("data-content"),
				style = self.attr("data-style") || "primary";
			this.template(heading, content, style, function(tooltip) {
				$("body").append(tooltip);
				$(".tooltip").css({
					top: top,
					left: left,
				}).show();
			})
		}
		var tooltipRemove = function() {
			$(".tooltip").remove();
		}
		return {
			display: tooltipDisplay,
			template: tooltipTemplate,
			remove: tooltipRemove
		}
	})();
	$('[data-action="tooltip"]').on({
		mouseenter: function(e) {
			tooltip.display($(this));
		},
		mouseleave: function(e) {
			tooltip.remove();
		}
	});
});