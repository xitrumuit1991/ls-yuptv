var request = require('request');
var async = require('async');

var layout = 'layout_paymentforapp';
var flag_mobile = true;

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


// router.get('/huong-dan',
obPaymentController.getPaymentHuongDan =  function(req, res)
{
  res.render('tutorial',
    {
      user: req.session.user,
      token: req.session.token,
      page_title: 'Hướng dẫn',
      flag_mobile: flag_mobile,
      layout : layout
    });
};



//router.get('/result/:id',
obPaymentController.getPaymentResult =  function(req, res)
{
  var id 			= req.params ? req.params.id :'' ;
  var transid 	= req.query ? req.query.transid : '';
  var responCode 	= req.query ? req.query.responCode : '';
  var mac 		= req.query ? req.query.mac : '';

  console.log('-----------response tu banking-------');
  console.log('id=',id);
  console.log('transid=',transid);
  console.log('responCode=',responCode);
  console.log('mac=',mac);
  request.post({
    url: req.configs.api_base_url + 'users/confirm',
    headers: {'content-type': 'application/json'},
    form: {id: id, transid: transid, responCode: responCode, mac: mac}
  }, function (error, response, body)
  {
    if (!error && response && response.statusCode == 200)
    {
      try{
        var confirm = JSON.parse(body);
        console.log('confirm megabank=',confirm);
        if( typeof (req.session.user) != 'undefined' && req.session.user !== undefined && req.session.user)
        {
          request({
            url: req.configs.api_base_url + 'users',
            headers: { 'content-type': 'application/json', 'Authorization': 'Token token=' + req.session.token}
          }, function (error, response, body)
          {
            if (!error && response && response.statusCode == 200)
            {
              try{
                req.session.user = JSON.parse(body);
                res.render('result',
                  {
                    token: req.session.token,
                    user: req.session.user,
                    confirm: confirm,
                    page_title: 'Thanh toán MegaBank',
                    flag_mobile:flag_mobile,
                    captcha: req.recaptcha,
                    layout : layout
                  });
              } catch(errorJSONParse) {
                console.error('ERROR get user profile after confirm megabank errorJSONParse=',errorJSONParse);
                res.status(400).json(errorJSONParse);
              }
            } else {
              console.error('ERROR when get user profile after confirm body=', body );
              res.render('error404',{
                message: body,
                status: 400,
                flag_mobile:flag_mobile,
                layout: layout
              });
            }
          });
        }
        else{
          // console.log('khong ton tai req.session.user');
          res.render('result',
            {
              user: req.session.user,
              token: req.session.token,
              page_title: page_title,
              confirm: confirm,
              captcha: req.recaptcha,
              flag_mobile:flag_mobile,
              layout : layout
            });
        }
      } catch(errorJSONParse)
      {
        console.error('ERROR api users/confirm; var confirm = JSON.parse(body); errorJSONParse=', errorJSONParse);
        res.status(400).json(errorJSONParse);
      }
    }else {
      var message = '';
      try { message = JSON.parse(body);
      }catch(e){ }
      res.render('result', {
        user: req.session.user,
        token: req.session.token,
        page_title: 'Thanh toán',
        message: message.error,
        flag_mobile: flag_mobile,
        layout : layout
      });
    }
  });
};


module.exports = obPaymentController;