// Begin Room preloader code
var text_Loader_Timeout, image_Loader_Timeout, loader_Status = 0;
loader_Timeout = {
	text: function(variable, timeout) {
		timeout = timeout || 2000;
		variable = setTimeout(function() { 
			var text_length = $(".preloader-loading-text").find('.loading-dot').text().length;
			if (text_length < 3) {
				$(".preloader-loading-text").find('.loading-dot').append(".");
			} else {
				$(".preloader-loading-text").find('.loading-dot').text(".");
			}
			loader_Timeout.text(variable, timeout)
		}, timeout);
	},
	image: function(variable, timeout) {
		timeout = timeout || 1000;
		variable = setTimeout(function() { 
			if (loader_Status < 90) {
				loader_Status += Math.floor(Math.random()*10);
				$(".preloader-after").height(loader_Status + '%')
			} 
			loader_Timeout.image(variable, timeout)
		}, timeout);
	}
}
loader_Timeout.image(image_Loader_Timeout, 2000);
loader_Timeout.text(text_Loader_Timeout, 500);
$(function() {
	// $("body").on('load', function(event) {
	setTimeout(function() { 
		var full_percentage = 100;
		var half_percentage = 50;
		clearTimeout(image_Loader_Timeout);
		// 
		loader_Number = Math.floor(Math.random()*10);
		var loader_Number = (loader_Number != 0) ? loader_Number : 1;
		loader_Status += Math.floor(full_percentage - (loader_Status + loader_Number));
		$(".preloader-after").height(loader_Status + '%');
		setTimeout(function() { 
			clearTimeout(text_Loader_Timeout);
			$(".preloader-after").height(full_percentage + '%');
			$(".livestar-preloader").fadeOut("slow");
		}, 500);
	}, 1000);
	// });
});
// En of Room preloader code