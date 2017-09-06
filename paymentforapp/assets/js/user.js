window.User = {};
User.reloadMoney = function () {
  if(user && typeof (user) != 'undefined' && user != null && token)
  {
    $.ajax({
      url: API_PATH + 'users/get-money',
      contentType: 'application/json',
      headers: { 'Authorization': 'Token token=' + token},
      method: 'GET',
      statusCode: {
        400: function(data)
        {
          // console.log(data);
        },
        200: function(data)
        {
          // console.log(data);
          var oldMoney = $('#user-money-top').text();
          if(data && data.money != oldMoney)
            $('#user-money-top').text(data.money);
        }
      }
    }).done(function (data) {
      // console.log(data);
    });
  }
};

User.reloadHeart = function () {
  if(user && typeof (user) != 'undefined' && user != null && token)
  {
    $.ajax({
      url: API_PATH + 'users/get-no-heart',
      contentType: 'application/json',
      headers: { 'Authorization': 'Token token=' + token},
      method: 'GET',
      statusCode: {
        400: function(data)
        {
          // console.log(data);
        },
        200: function(data)
        {
          // console.log(data);
          var oldHeart = $('#btn-send-heart').attr('data-heart');
          if(data && data.no_heart != oldHeart)
            $('#btn-send-heart').attr('data-heart', data.no_heart);
        }
      }
    }).done(function (data) {
      // console.log(data);
    });
  }
};

User.reloadShareOfRoom =function (room_id) {
  
};

User.reloadHeartOfRoom =function (room_id) {

};