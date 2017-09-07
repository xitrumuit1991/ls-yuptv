var request = require('request');
var async = require('async');
var underscore = require('underscore');

var layout = 'layout_paymentforapp';
var flag_mobile = true;

var requestApi = function (options,callback) {
  request({
    url:options.url,
    method:options.method ? options.method : 'GET',
    body:options.body ? options.body : null,
    headers:options.headers ? options.headers : {}
  },function (error,response,body) {
    if (!error && response && response.statusCode == 200) {
      try {
        var data = JSON.parse(body);
        // console.log('sms=', JSON.stringify(sms));
        if (data) return callback(null,data);
        return callback(null,null);
      }
      catch (errorJSONParse) {
        console.error('ERROR ' + options.url,errorJSONParse);
        callback(errorJSONParse,null);
      }
    } else {
      console.error('ERROR ' + options.url,body);
      callback(body,null);
    }
  });
};

var obPaymentController = {};
obPaymentController.getPaymentView = function (req,res)
{
  // console.log('req.query=',req.query);
  var queryToken = ((req && req.query) ? req.query.token : '');
  // console.log('queryToken=',queryToken);
  async.parallel({
      resultPayment : function (callback) {
        requestApi({url:req.configs.api_base_url + 'payment/package'},callback);
      },
      user:function (callback) {
        requestApi({
          url:req.configs.api_base_url + 'auth/verify-token?token=' + req.session.token,
          headers:{'Authorization' : req.session.token}
        },function (error,result) {
          if (error) {
            if (req.session && req.session.user) return callback(null,req.session.user);
            return callback(null,null);
          }
          if(result )
            return callback(null,result);
          return callback(null, null );
        });
      }
    },
    function (err,results)
    {
      var megabanks =  [];
      var banks =  [];
      var provider = [];
      var sms =  [];
      // console.log(results);
      if (err) {
        console.error(err);
        return res.json({message: 'ERROR! Có lỗi xảy ra', detail : 'Can not get api list packages'})
      }
      megabanks =  results.resultPayment['bank'].Packages;
      banks =  results.resultPayment['bank'].Sources;
      provider =  results.resultPayment['telco'].Sources;
      sms =  results.resultPayment['sms'].Packages;

      if (!queryToken || queryToken == '') {
        return res.render('index',{
          user:results.user,
          token:req.session.token,
          banks: banks,
          megabanks : megabanks,
          providers: provider,
          sms: sms,
          page_title:'Thanh toán',
          flag_mobile:flag_mobile,
          layout:layout
        });
      }
      if (queryToken && queryToken != '') {
        requestApi({
          url:req.configs.api_base_url + 'auth/verify-token?token=' + queryToken,
          headers:{'Authorization' : queryToken}
        },function (error,result) {
          console.log(result);
          if (error) return res.redirect('/paymentforapp');
          if (result) {
            req.session.user = result;
            req.session.token = queryToken;
            return res.redirect('/paymentforapp');
          } else {
            return res.render('index',{
              user:results.user,
              token:req.session.token,
              banks: banks,
              megabanks : megabanks,
              providers: provider,
              sms: sms,
              page_title:'Thanh toán',
              flag_mobile:flag_mobile,
              layout:layout
            });
          }
        });
        return;
      }
    });
};

// router.get('/huong-dan',
obPaymentController.getPaymentHuongDan = function (req,res) {
  return res.render('tutorial',
    {
      user:req.session.user,
      token:req.session.token,
      page_title:'Hướng dẫn',
      flag_mobile:flag_mobile,
      layout:layout
    });
};

//router.get('/result/:id',
obPaymentController.getPaymentResult = function (req,res) {
  var id = req.params ? req.params.id : '';
  var transid = req.query ? req.query.transid : '';
  var responCode = req.query ? req.query.responCode : '';
  var mac = req.query ? req.query.mac : '';

  console.log('-----------response tu banking-------');
  console.log('id=',id);
  console.log('transid=',transid);
  console.log('responCode=',responCode);
  console.log('mac=',mac);
  request.post({
    url:req.configs.api_base_url + 'users/confirm',
    headers:{'content-type':'application/json'},
    form:{id:id,transid:transid,responCode:responCode,mac:mac}
  },function (error,response,body) {
    if (!error && response && response.statusCode == 200) {
      try {
        var confirm = JSON.parse(body);
        console.log('confirm megabank=',confirm);
        if (typeof (req.session.user) != 'undefined' && req.session.user !== undefined && req.session.user) {
          request({
            url:req.configs.api_base_url + 'auth/verify-token?token=' + req.session.token,
            headers:{'content-type':'application/json','Authorization' : req.session.token}
          },function (error,response,body) {
            if (!error && response && response.statusCode == 200) {
              try {
                req.session.user = JSON.parse(body);
                res.render('result',
                  {
                    token:req.session.token,
                    user:req.session.user,
                    confirm:confirm,
                    page_title:'Thanh toán MegaBank',
                    flag_mobile:flag_mobile,
                    captcha:req.recaptcha,
                    layout:layout
                  });
              }
              catch (errorJSONParse) {
                console.error('ERROR get user profile after confirm megabank errorJSONParse=',errorJSONParse);
                res.status(400).json(errorJSONParse);
              }
            } else {
              console.error('ERROR when get user profile after confirm body=',body);
              res.render('error404',{
                message:body,
                status:400,
                flag_mobile:flag_mobile,
                layout:layout
              });
            }
          });
        }
        else {
          // console.log('khong ton tai req.session.user');
          res.render('result',
            {
              user:req.session.user,
              token:req.session.token,
              page_title:page_title,
              confirm:confirm,
              captcha:req.recaptcha,
              flag_mobile:flag_mobile,
              layout:layout
            });
        }
      }
      catch (errorJSONParse) {
        console.error('ERROR api users/confirm; var confirm = JSON.parse(body); errorJSONParse=',errorJSONParse);
        res.status(400).json(errorJSONParse);
      }
    } else {
      var message = '';
      try {
        message = JSON.parse(body);
      }
      catch (e) { }
      res.render('result',{
        user:req.session.user,
        token:req.session.token,
        page_title:'Thanh toán',
        message:message.error,
        flag_mobile:flag_mobile,
        layout:layout
      });
    }
  });
};

module.exports = obPaymentController;