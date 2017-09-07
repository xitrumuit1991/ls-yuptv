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
var RedisService = require('./RedisService');
var app = express();
RedisService.init();

app.use(session({
  store: new RedisStore({ client :  RedisService.getClient() }),
  secret: configs.redis.secret,
  resave:false,
  saveUninitialized:true,
  cookie: true
}));

recaptcha.init(configs.web_SITE_KEY,configs.web_SECRET_KEY);

app.set('trust proxy',1);
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'paymentforapp'));
app.set('layout', path.join(__dirname, 'paymentforapp') );

app.use(expressLayouts);
app.use(helmet());
app.use(flash());
app.use(compression());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:false}));
app.use(cookieParser());



app.use(function(req, res, next)
{
  app.locals = {configs : configs, version : '1.0.0'};
  req.configs = configs;
  if (req && !req.session) return next(new Error('ERROR: can not connect Redis'+configs.redis_host));
  //check web mobile here
  return next();
});


app.get('/health_check', function (req, res) { res.json({service : 'livestar web v2', time : (new Date()).getTime(), message : 'ok' }) });



//group payment app
var paymentController = require('./paymentforapp/controller');
app.use('/assets', express.static(__dirname + '/paymentforapp/assets'));
app.get('/paymentforapp', paymentController.getPaymentView);
app.get('/paymentforapp/huong-dan', paymentController.getPaymentHuongDan);
app.get('/paymentforapp/result/:id', paymentController.getPaymentResult);
//end group payment app



app.use(express.static('www'));
app.all('/*', function (req, res, next) {
  res.sendfile('index.html', { root: __dirname + '/www' });
});

app.listen(configs.port);
console.log('Livestar WEB V2 - started at port :' + configs.port);