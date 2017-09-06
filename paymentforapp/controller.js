var request = require('request');
var async = require('async');

var obPaymentController = {};
obPaymentController.getPaymentView = function(req, res)
{
  var queryToken = ((req && req.query) ? req.query.token:'');
  // console.log('req.configs.api_base_url =',req.configs.api_base_url );
  async.parallel({
      sms: function(callback)
      {
        request({
          url: req.configs.api_base_url + 'users/get-sms'
        }, function (error, response, body)
        {
          if (!error && response && response.statusCode == 200)
          {
            try{
              var sms = JSON.parse(body);
              // console.log('sms=', JSON.stringify(sms));
              if(sms)
                return callback(null, sms);
              return callback(null, null);
            } catch(errorJSONParse)
            {
              console.error('payment get list users/get-sms error', errorJSONParse);
              callback(null, null);
            }
          } else {
            console.error('payment get list users/get-sms error', body);
            callback(null, null);
          }
        });
      },
      provider: function(callback)
      {
        request({
          url: req.configs.api_base_url + 'users/get-providers'
        }, function (error, response, body)
        {
          if (!error && response && response.statusCode == 200)
          {
            try{
              var provider = JSON.parse(body);
              // console.log('provider=', JSON.stringify(provider));
              if(provider)
                return callback(null, provider);
              return callback(null, null);
            } catch(errorJSONParse)
            {
              console.error('ERROR provider users/get-providers=',errorJSONParse);
              callback(null, null);
            }
          } else {
            console.error('ERROR provider users/get-providers=',body);
            callback(null, null);
          }
        });
      },
      banks: function(callback)
      {
        request({
          url: req.configs.api_base_url + 'users/get-banks'
        }, function (error, response, body)
        {
          if (!error && response && response.statusCode == 200) {
            try{
              var banks = JSON.parse(body);
              // console.log('banks=', JSON.stringify(banks));
              if(banks)
                return callback(null, banks);
              return callback(null,null);
            } catch(errorJSONParse)
            {
              console.error('banks banks users/get-banks=',errorJSONParse);
              callback(null, null);
            }
          } else {
            console.error('banks banks users/get-banks=',body);
            callback(null, null);
          }
        });
      },
      user: function(callback)
      {
        request({
          url: req.configs.api_base_url + 'users',
          headers: { 'Authorization': 'Token token=' + req.session.token}
        }, function (error, response, body)
        {
          if (!error && response && response.statusCode == 200)
          {
            try{
              var userData = JSON.parse(body);
              // console.log('userData=', JSON.stringify(userData));
              if(userData)
                return callback(null, userData);
              return callback(null, null);
            } catch(errorJSONParse) {
              console.error('ERROR user users/get-banks=',errorJSONParse);
              callback(null, null);
            }
          } else {
            console.error('ERROR user users/get-banks=',body);
            if(req.session && req.session.user)
              return callback(null, req.session.user);
            return callback(null, null);
          }
        });
      },
      megabanks: function(callback){
        request({
          url: req.configs.api_base_url + 'users/get-megabanks'
        }, function (error, response, body)
        {
          if (!error && response && response.statusCode == 200)
          {
            try{
              var megabanks = JSON.parse(body);
              // console.log('megabanks=', JSON.stringify(megabanks));
              if(megabanks)
                return callback(null, megabanks);
              return callback(null, null);
            } catch(errorJSONParse) {
              console.error('ERROR megabanks users/get-megabanks=',errorJSONParse);
              callback(null, null);
            }
          } else {
            console.error('ERROR megabanks users/get-megabanks=',body);
            callback(null, null);
          }
        });
      }
    },
    function(err, results)
    {
      var flag_mobile = true;
      var layout = 'layout_paymentforapp';
      if(err){
        console.error(err);
        console.error(results);
        // return res.render('error404',{message: err,status: 400, layout: false});
        return res.render('index', {
          user: results.user,
          token: req.session.token,
          banks: results.banks,
          megabanks: results.megabanks,
          providers: results.provider,
          sms: results.sms,
          page_title: 'Thanh toán',
          flag_mobile: flag_mobile,
          message : 'Có lỗi khi load trang. Vui lòng thử lại.',
          layout : layout
        });
      }
      // var ua = req.headers['user-agent'];
      // if(/mobile/i.test(ua)) flag_mobile = true;
      if(!queryToken || queryToken=='')
      {
        return res.render('index', {
          user: results.user,
          token: req.session.token,
          banks: results.banks,
          megabanks: results.megabanks,
          providers: results.provider,
          sms: results.sms,
          page_title: 'Thanh toán',
          flag_mobile: flag_mobile,
          layout : layout
        });
      }
      if(queryToken && queryToken!='' )
      {
        request({
          url: req.configs.api_base_url + 'users',
          headers: {'Authorization': 'Token token=' + queryToken}
        }, function (error, response, body)
        {
          if(error || (response && response.statusCode != 200) )
            return res.redirect('/paymentforapp');
          if (response && response.statusCode == 200)
          {
            try{
              var userToken = JSON.parse(body);
              if(typeof(userToken)!='undefined' && userToken!=undefined && userToken.id)
              {
                req.session.user = userToken;
                req.session.token = queryToken;
                return res.redirect('/paymentforapp');
              }
              return res.render('index', {
                user: results.user,
                token: req.session.token,
                banks: results.banks,
                megabanks: results.megabanks,
                providers: results.provider,
                sms: results.sms,
                page_title: 'Thanh toán',
                flag_mobile: flag_mobile,
                layout : layout
              });
            } catch(errorJSONParse)
            {
              return res.render('index', {
                user: results.user,
                token: req.session.token,
                banks: results.banks,
                megabanks: results.megabanks,
                providers: results.provider,
                sms: results.sms,
                page_title: 'Thanh toán',
                flag_mobile: flag_mobile,
                layout : layout
              });
            }
          }
        });
        return;
      }
    });
};

module.exports = obPaymentController;