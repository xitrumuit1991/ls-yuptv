var request = require('request');
var async = require('async');
var underscore = require('underscore');

var layout = 'paymentforapp/layout_paymentforapp';
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
obPaymentController.getSession = function (req,res){
  res.json({
    message : 'session livestar web v2',
    session : req.session,
    user : req.session ? req.session.user : '',
    token : req.session ? req.session.token : '',
  });
};
obPaymentController.getPaymentView = function (req,res)
{
  var queryToken = ((req && req.query) ? req.query.token : '');
  console.log('queryToken=',queryToken);
  async.parallel({
      resultPayment : function (callback) {
        requestApi({url:req.configs.api_base_url + 'payment/package'},callback);
      },
      user:function (callback) {
        if (req.session && !req.session.token)
          return callback(null, null);
        requestApi({
          url:req.configs.api_base_url + 'auth/verify-token?token=' + req.session.token,
          headers:{'Authorization' : req.session.token}
        },function (error,result) {
          if (error) {
            if (req.session && req.session.user)
              return callback(null,req.session.user);
            return callback(null,null);
          }
          if(result )
          {
            return callback(null,result);
          }else{
            return callback(null, null );
          }
        });
      }
    },
    function (err,results)
    {
      // console.log(results);
      if (err) {
        console.log('ERROR auth/verify-token?token', err);
        console.log('ERROR! Có lỗi xảy ra', err);
        return res.redirect('/paymentforapp');
      }
      var megabanks = ( results && results.resultPayment ) ? results.resultPayment['bank'].Packages : [];
      var banks =  ( results && results.resultPayment ) ? results.resultPayment['bank'].Sources : [];
      var provider = ( results && results.resultPayment ) ?  results.resultPayment['telco'].Sources : [];
      var sms =  ( results && results.resultPayment ) ?  results.resultPayment['sms'].Packages : [];

      if (!queryToken || queryToken == '')
      {
        console.log('Not found queryToken; queryToken=', queryToken);
        return res.render('paymentforapp/index',{
          user: results.user,
          token: req.session ? req.session.token : '',
          banks: banks,
          megabanks : megabanks,
          providers: provider,
          sms: sms,
          page_title:'Thanh toán',
          flag_mobile:flag_mobile,
          layout:layout
        });
      }
      else{
        console.log('has queryToken; queryToken=', queryToken);
        requestApi({
          url:req.configs.api_base_url + 'auth/verify-token?token=' + queryToken,
          headers:{'Authorization' : queryToken}
        },function (error,result) {
          console.log(result);
          if (error) {
            console.log('ERROR auth/verify-token?token', error);
            return res.redirect('/paymentforapp');
          }
          if (result) {
            req.session.user = result;
            req.session.token = queryToken;
            return res.redirect('/paymentforapp');
          } else {
            return res.render('paymentforapp/index',{
              user:results.user,
              token:req.session ? req.session.token : '',
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
      }
    });
};

// router.get('/huong-dan',
obPaymentController.getPaymentHuongDan = function (req,res) {
  return res.render('paymentforapp/tutorial',
    {
      user:req.session.user,
      token:req.session.token,
      page_title:'Hướng dẫn',
      flag_mobile:flag_mobile,
      layout:layout
    });
};


obPaymentController.getPaymentBankResult = function (req,res) {
  //transid=BANK_1510634097113&responCode=00&mac=41B7B1C385CBEA0E74DB017B035D49DA8D8F3BD3719FD105
  var transId =     req.query ? req.query.transid : '';
  var responseCode =  req.query ? req.query.responCode : '';
  var mac =         req.query ? req.query.mac : '';
  console.log('-----------response tu banking-------');
  console.log('transid=',transId);
  console.log('responseCode=',responseCode);
  console.log('mac=',mac);
  if( !transId || !responseCode || !mac)
  {
    return res.status(400).json({
      error : '1',
      message : 'missing param',
      data : {
        transId : transId,
        responseCode : responseCode,
        mac : mac
      }
    });
  }
  request({
    method : 'GET',
    url : req.configs.api_base_url + 'payment/bank-callback?transId='+transId+'&responseCode='+responseCode+'&mac='+mac,
    headers : {'content-type':'application/json', 'Authorization' : req.session.token}
  },function (error,response,body) {
    console.log('message tu API body=', body);
    if (!error && response && response.statusCode == 200)
    {
      try {
        var confirm = JSON.parse(body);
        console.log('confirm megabank=',confirm);
        if (typeof (req.session.user) != 'undefined' && req.session.user)
        {
          request({
            url:req.configs.api_base_url + 'auth/verify-token?token=' + req.session.token,
            headers:{'content-type':'application/json','Authorization' : req.session.token}
          },function (error,response,body)
          {
            if (!error && response && response.statusCode == 200) {
              try {
                req.session.user = JSON.parse(body);
                var paramsData = {
                  token:req.session.token,
                  user:req.session.user,
                  confirm:confirm,
                  page_title:'Thanh toán MegaBank',
                  flag_mobile:flag_mobile,
                  layout:layout
                };
                console.log('paramsData=',paramsData);
                res.render('paymentforapp/result',paramsData );
              }
              catch (errorJSONParse) {
                console.error('ERROR get user profile after confirm megabank errorJSONParse=',errorJSONParse);
                res.status(400).json(errorJSONParse);
              }
            } else {
              console.error('ERROR when get user profile after confirm body=',body);
              res.status(400).json({
                message:body,
                status:400
              });
            }
          });
        }
        else {
          // console.log('khong ton tai req.session.user');
          res.render('paymentforapp/result',
            {
              user:req.session.user,
              token:req.session.token,
              page_title: 'Thanh Toán',
              confirm:confirm,
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
      console.log('payment/bank-callback ERROR=', error);
      try { message = JSON.parse(body); }
      catch (e) { message = ''; }
      res.render('paymentforapp/result',{
        user:req.session.user,
        token:req.session.token,
        page_title:'Thanh toán',
        message: (message && message.error) ? message.error : message,
        flag_mobile:flag_mobile,
        layout:layout
      });
    }
  });
};

module.exports = obPaymentController;