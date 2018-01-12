var express = require('express');
var path = require('path');
var flash = require('connect-flash');
var expressLayouts = require('express-ejs-layouts');
var cookieParser = require('cookie-parser');
var session = require('express-session');
var RedisStore = require('connect-redis')(session);
var recaptcha = require('express-recaptcha');
var helmet = require('helmet');
var compression = require('compression');
var bodyParser = require('body-parser');
var request = require('request');
var async = require('async');
var underscore = require('underscore');

var configs = require('./config_server');
console.log('--------------------config_server---------------');
console.log('--------------------',configs);
var RedisService = require('./RedisService');
var app = express();
RedisService.init();
// console.log('--------------------redis store client---------------');
// console.log('--------------------',RedisService.getClient());
app.use(session({
  store:new RedisStore({client:RedisService.getClient()}),
  secret:configs.redis.secret,
  resave:false,
  saveUninitialized:true,
  cookie:true
}));

// recaptcha.init(configs.web_SITE_KEY,configs.web_SECRET_KEY);

app.set('trust proxy',1);
app.set('view engine','ejs');
app.set('views',path.join(__dirname,'views'));
app.set('layout',path.join(__dirname,'views'));
app.use('/assets',express.static(__dirname + '/assets'));
app.use(expressLayouts);
app.use(helmet());
app.use(flash());
app.use(compression());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:false}));
app.use(cookieParser());

app.use(function (req,res,next) {
  app.locals = {configs:configs,version:'1.0.0'};
  req.configs = configs;
  if (req && !req.session) return next(new Error('ERROR: can not connect Redis' + configs.redis.host));
  var ua = req.headers['user-agent'];
  var isMobile = (/mobile/i.test(ua)) ? true : false;

  if (isMobile == true) {
    if (req.originalUrl && req.originalUrl.indexOf('voteapp') != -1) {
      return next();
    }
    if (req.originalUrl && req.originalUrl.indexOf('paymentforapp') != -1)
      return next();
    if (req.originalUrl && req.originalUrl.indexOf('download/ios') != -1)
      return next();
    if (req.originalUrl && req.originalUrl.indexOf('download/android') != -1)
      return next();
    if (req.originalUrl && req.originalUrl.indexOf('down-app') == -1)
      return res.redirect('/down-app');
  }
  if (isMobile == false && req.originalUrl && req.originalUrl.indexOf('down-app') != -1)
    return res.redirect('/');
  return next();
});

app.get('/voteapp',function (req,res) {
  var MobileDetect = require('mobile-detect'),md = new MobileDetect(req.headers['user-agent']);
  var os = md.os() ? md.os().toLowerCase() : 'unknown';
  return res.render('redirectToStore',{
    layout:false,
    type:( os == 'androidos' ? 'android' : (os == 'ios' ? 'ios' : 'unknown'))
  });
});

app.get('/download/ios',function (req,res) {
  return res.render('redirectToStore',{layout:false,type:'ios'});
});
app.get('/download/android',function (req,res) {
  return res.render('redirectToStore',{layout:false,type:'android'});
});

app.get('/down-app',function (req,res) {
  var MobileDetect = require('mobile-detect'),md = new MobileDetect(req.headers['user-agent']);
  var os = md.os() ? md.os().toLowerCase() : 'unknown';
  return res.render('landing-down-app-view',{
    layout:false,
    os:( os == 'androidos' ? 'android' : (os == 'ios' ? 'ios' : 'unknown'))
  });
});
app.get('/health_check',function (req,res) { res.json({service:'livestar web v2',time:(new Date()).getTime(),message:'ok'}) });

app.get('/room-detail/:id',function (req,res,next) {
  //share or SEO facebook og:tag
  var id = req.params ? req.params.id : '';
  var userAgent = req.headers['user-agent'];
  console.log('----------------------------');
  console.log('id',id);
  console.log('userAgent',userAgent);
  if(!id) return next();
  if (userAgent.startsWith('facebookexternalhit/1.1') || userAgent === 'Facebot' || userAgent.startsWith('Twitterbot')) {
    request({
      url: configs.api_base_url+'room/' + id + '/',
      method:'GET'
    },function (error,response,body) {
      if (error) return next();
      if (response && response.statusCode != 200)
        return next();
      if (response && !body) return next();
      try {
        var data = JSON.parse(body);
        console.log('configs.api_base_url',data);
        if (!data) return next();
        var dataPass = {
          layout:false,
          og_title:(data.title || 'YUP - Ứng dụng livestream kiếm tiền số 1'),
          og_url: configs.link_website + 'room-detail/' + data.id,
          og_description:(data.description || 'Tự tin tỏa sáng, thỏa sức kiếm tiền. YUP - Ứng dụng livestream kiếm tiền số 1'),
          og_image:(data.banner || data.background || (data.User ? data.User.avatar : 'http://yuptv.vn/images/Ve_Yup.png' ) ),
          id:data.id
        };
        console.log('dataPass',dataPass);
        return res.render('bot-room-detail-for-share-social',dataPass);
      }
      catch (errorJSONParse) {
        console.log('errorJSONParse',errorJSONParse);
        return next();
      }
    });
  }
  return next();
});

//group payment app
var paymentController = require('./controller/paymentforappController');
app.get('/paymentforapp',paymentController.getPaymentView);
app.get('/paymentforapp/session',paymentController.getSession);
app.get('/paymentforapp/huong-dan',paymentController.getPaymentHuongDan);
app.get('/paymentforapp/bank/result',paymentController.getPaymentBankResult);
//end group payment app

app.use(express.static('www'));
app.all('/*',function (req,res,next) {
  // Just send the index.html for other files to support HTML5Mode
  res.sendfile('index.html',{root:__dirname + '/www'});
});


app.listen(configs.port);
console.log('Livestar WEB V2 - started at port :' + configs.port);