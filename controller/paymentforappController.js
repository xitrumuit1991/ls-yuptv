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
  if( queryToken === '' || !queryToken )
    queryToken = req.session.token;
  async.parallel({
      resultPayment : function (callback) {
        requestApi(
        {
          url:req.configs.api_base_url + 'payment/package?token='+queryToken,
          headers:{'Authorization' : queryToken}
        },callback);
      },
      user:function (callback) {
        requestApi({
          url:req.configs.api_base_url + 'auth/verify-token?token=' + queryToken,
          headers:{'Authorization' : queryToken}
        },function (error,result) {
          if (error)
          {
            //if (req.session && req.session.user)
            //  return callback(null,req.session.user);
            req.session.token = null;
            req.session.user = null;
            return callback(null,null);
          }
          if(!result) return callback(null, null);
          req.session.user = result;
          if(queryToken)
            req.session.token = queryToken;
          return callback(null,result);
        });
      }
    },
    function (err,results)
    {
      if (err) {
        console.log('ERROR auth/verify-token?token', err);
        console.log('ERROR! Có lỗi xảy ra', err);
        return res.redirect('/paymentforapp');
      }
      var megabanks = ( results && results.resultPayment ) ? results.resultPayment['bank'].Packages : [];
      var banks =  ( results && results.resultPayment ) ? results.resultPayment['bank'].Sources : [];
      var provider = ( results && results.resultPayment ) ?  results.resultPayment['telco'].Sources : [];
      var sms =  ( results && results.resultPayment ) ?  results.resultPayment['sms'].Packages : [];

      return res.render('paymentforapp/index',{
        user: req.session.user,
        token: req.session.token,
        banks: banks,
        megabanks : megabanks,
        providers: provider,
        sms: sms,
        page_title:'Thanh toán',
        flag_mobile:flag_mobile,
        layout:layout
      });
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
  var transid =     req.query ? req.query.transid : '';
  var responCode =  req.query ? req.query.responCode : '';
  var mac =         req.query ? req.query.mac : '';
  console.log('-----------getPaymentBankResult response tu banking-------');
  console.log('transid=',transid);
  console.log('responCode=',responCode);
  console.log('mac=',mac);
  if( !transid || !responCode || !mac)
  {
    return res.status(400).json({ error : '1', message : 'missing param', data : { transid : transid,  responCode : responCode, mac : mac } });
  }
  var optionRequestBankCallback = {
    method : 'GET',
    url : req.configs.api_base_url + 'payment/bank-callback?transid='+transid+'&responCode='+responCode+'&mac='+mac,
    headers : {'content-type':'application/json', 'Authorization' : req.session.token}
  };
  console.log('optionRequestBankCallback',optionRequestBankCallback);
  request(optionRequestBankCallback ,function (error,response,body)
  {
    console.log('payment/bank-callback; message tu API body=', body);
    if(response)
      console.log('payment/bank-callback; response.statusCode=', response.statusCode);

    if(error)
    {
      var paramsData = {
        token:req.session.token,
        user:req.session.user,
        message : JSON.stringify(error),
        status : 400,
        page_title:'Thanh toán MegaBank',
        flag_mobile:flag_mobile,
        layout:layout
      };
      console.log('error; paramsData=',paramsData);
      res.render('paymentforapp/result',paramsData );
      return;
    }

    if(response && response.statusCode != 200 && body)
    {
      var dataParse = null;
      try {
        dataParse = JSON.parse(body);
        console.log('response.statusCode != 200; result=',dataParse);
      }catch (e){ dataParse=null; }
      var paramsData = {
        token:req.session.token,
        user:req.session.user,
        message : (dataParse && dataParse.message ) ? dataParse.message : 'Có lỗi xảy ra. Vui lòng thử lại !',
        status :  (dataParse && dataParse.status ) ? dataParse.status : '400',
        page_title:'Thanh toán MegaBank',
        flag_mobile:flag_mobile,
        layout:layout
      };
      console.log('response.statusCode != 200; paramsData=',paramsData);
      res.render('paymentforapp/result',paramsData );
      return;
    }


    if (response && response.statusCode == 200)
    {
      try {
        var confirm = JSON.parse(body);
        console.log('JSON.parse(body); confirm megabank=',confirm);
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
                  // money : req.session.user ? req.session.user.money : '',
                  message : confirm ? confirm.message : '',
                  status : confirm ? confirm.status : '',
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
                error : error,
                status: (response && response.statusCode) ? response.statusCode : ''
              });
            }
          });
        }
        else {
          res.render('paymentforapp/result',
            {
              user:req.session.user,
              token:req.session.token,
              page_title: 'Thanh Toán',
              // confirm:confirm,
              message : 'User chưa login, giao dịch không hợp lệ',
              status : 400,
              flag_mobile:flag_mobile,
              layout:layout
            });
        }
      }
      catch (errorJSONParse) {
        console.error('ERROR api users/confirm; var confirm = JSON.parse(body); errorJSONParse=',errorJSONParse);
        res.status(400).json(errorJSONParse);
      }
    }
    // else {
    //   var message = '';
    //   console.log('payment/bank-callback ERROR=', error);
    //   try { message = JSON.parse(body); }
    //   catch (e) { message = ''; }
    //   res.render('paymentforapp/result',{
    //     user:req.session.user,
    //     token:req.session.token,
    //     page_title:'Thanh toán',
    //     message: (message && message.error) ? message.error : message,
    //     flag_mobile:flag_mobile,
    //     layout:layout
    //   });
    // }
  });
};

module.exports = obPaymentController;