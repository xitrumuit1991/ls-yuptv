//set config redis here
var configs = require('./config_server');

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
var app = express();

var sessionStore = new RedisStore({host:configs.redis_host,port:configs.redis_port,ttl:3600});
app.use(session({
  store: sessionStore,
  secret:configs.redis_session_secret,
  resave:false,
  saveUninitialized:true,
  cookie: true
}));

recaptcha.init(configs.web_SITE_KEY,configs.web_SECRET_KEY);

app.set('trust proxy',1);
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'paymentforapp'));
// app.set('layout', 'paymentforapp/layout');
app.set('layout', path.join(__dirname, 'paymentforapp') );

app.use(expressLayouts);
app.use(helmet());
app.use(flash());
app.use(compression());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:false}));
app.use(cookieParser());

app.locals = {configs : configs};

app.use(function(req, res, next)
{
  req.configs = configs;
  if (req && !req.session) return next(new Error('ERROR: can not connect Redis'+configs.redis_host));
  app.locals.version = '1.0.0';
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

app.listen(configs.port); //the port you want to use
console.log('Livestar WEB V2 - App started at port :' + configs.port);