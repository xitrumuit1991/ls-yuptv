var PModal = {}

PModal.modalAlert = function(message, callback){
	$('#modal_livestar_btn_no').hide();
	$('#modal_livestar_btn_yes').html('OK');
	$('#modal_Livestar').find('p').html(message);
	if(callback !== undefined){
		$('#modal_livestar_btn_yes').one("click", callback);
	}
	$('#modal_Livestar').modal('show');
}

PModal.modalConfirm = function(message, callback){
	$('#modal_livestar_btn_no').html('Không');
	$('#modal_livestar_btn_yes').html('Có');
	$('#modal_Livestar').find('p').html(message);
    if(callback !== undefined){
        $('#modal_livestar_btn_yes').one("click", callback);
        $('#modal_livestar_btn_no').off("click");
	}
	$('#modal_Livestar').modal('show');	
}

PModal.modalSmsMbpVnp = function(code, name, money, coin, callback){
    $('#modal_livestar_btn_no').hide();
    $('#modal_livestar_btn_yes').html('Đóng');
    var message = '<span>Gói cước dành cho thuê bao<br/>';
	message += (typeof user == 'undefined' || (typeof user != 'undefined' && !user.is_mbf)) ? 'Mobifone và Vinaphone ' : 'Vinaphone</span>';
    $('#modal_Livestar').find('h3').html(message);
    var sms = '<strong class="color-primary">MW LIVESTAR NAP'+money+' '+code+'</strong> gửi đến <strong class="color-primary">9029</strong>';
        sms += '<br/><br/> Vui lòng tải lại trang khi nhận thông báo thành công';
    $('#modal_Livestar').find('p').html(sms);
    if(callback !== undefined){
        $('#modal_livestar_btn_yes').one("click", callback);
    }
    $('#modal_Livestar').modal('show');    
}
PModal.modalSmsMbp = function(code, name, money, coin, callback){
    $('#modal_livestar_btn_no').hide();
    $('#modal_livestar_btn_yes').html('Đóng');
    var message = '<span>Gói Vip dành cho thuê bao<br/>Mobifone</span>';
    $('#modal_Livestar').find('h3').html(message);
    var sms = '<strong">Soạn tin theo cú pháp: </strong>';
    sms += '<br/><strong class="color-primary">XU'+coin+ '</strong> gửi đến<strong class="color-primary"> 9387</strong>';
    sms += '<br/><br/> Để nhận ' + coin+'xu với giá '+ money+'đ';
    $('#modal_Livestar').find('p').html(sms);
    if(callback !== undefined){
        $('#modal_livestar_btn_yes').one("click", callback);
    }
    $('#modal_Livestar').modal('show');
}

PModal.modalSmsVt = function(code, name, money, coin, callback){
    $('#modal_livestar_btn_no').hide();
    $('#modal_livestar_btn_yes').html('Đóng');
    var message = '<span>Gói cước dành cho thuê bao<br/>Viettel</span>';
    $('#modal_Livestar').find('h3').html(message);
    var sms = '<strong class="color-primary">MW '+money+' LIVESTAR NAP '+code+'</strong> gửi đến <strong class="color-primary">9029</strong>';
        sms += '<br/><br/> Vui lòng tải lại trang khi nhận thông báo thành công';
    $('#modal_Livestar').find('p').html(sms);
    if(callback !== undefined){
        $('#modal_livestar_btn_yes').one("click", callback);
    }
    $('#modal_Livestar').modal('show');
}

PModal.modalConfirmVip = function(name, money, image, callback){
	$('#modal_vip_livestar_btn_no').show();
	$('#modal_vip_livestar_btn_yes').html('Có');
	$('#modal_Vip').find('h4').html(name);
	$('#modal_Vip .coin').html(money);
	var htmlImage = '<img src="'+image+'" alt="'+name+'" />'
	$('#modal_Vip .image').html(htmlImage);
	if(callback !== undefined){
		$('#modal_vip_livestar_btn_yes').one("click", callback);
	}
	$('#modal_Vip').modal('show');	
}

PModal.modalVipMbp = function(code, name, money, day, callback){
    $('#modal_livestar_btn_no').hide();
    $('#modal_livestar_btn_yes').html('Đóng');
    var message = '<span>Gói Vip dành cho thuê bao Mobifone</span>';
    $('#modal_Livestar').find('h3').html(message);
    var sms = '<strong">Soạn tin theo cú pháp: </strong>';
    sms += '<br/><strong class="color-primary">'+code+ '</strong> gửi đến<strong class="color-primary"> 9387</strong>';
    sms += '<br/><br/> Để trở thành ' + code+' với giá cước '+ money+'đ/'+ day +' ngày';
    $('#modal_Livestar').find('p').html(sms);
    if(callback !== undefined){
        $('#modal_livestar_btn_yes').one("click", callback);
    }
    $('#modal_Livestar').modal('show');
}

PModal.modalCoins = function(money, name, coin, callback){
    $('#modal_livestar_btn_no').html('Nạp Tiền');
    $('#modal_livestar_btn_yes').html('Chia Sẻ');
    var messagecoin = '<p>Sắp hết xu rồi cưng, nạp xu hoặc chia sẻ lên facebook để kiếm <strong class="color-primary">'+coin+'</strong> xu MIỄN PHÍ nha !</p>';
    $('#modal_Livestar').find('p').html(messagecoin);
    if(callback !== undefined){
        $('#modal_livestar_btn_yes').one("click", callback);
        $('#modal_livestar_btn_no').one("click", function(){
            window.location.href = "/payment";
        });
    }
    $('#modal_Livestar').modal('show');
}