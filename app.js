var configs = {
  port: 5002,
  redis_host: "localhost",
  redis_port: 6379,
  redis_session_secret: "1BCB58514FCE3C7C66BB6C91ACD88",
  serve_static: true,

  web_domain: "local.livestar.vn",
  wap_domain: "m-local.livestar.vn",

  live_path: "http://localhost:5001/",
  api_domain: "http://localhost:3000",

  // api_base_url: "http://localhost:3000/api/v1/",
  api_base_url: "http://api.livestar.vn/api/v1/",

  api_secrect_key: "fQ+KY11&l624Bu5",
  web_SITE_KEY: "6LdVAxkTAAAAAAeES9kxnsXGbKuW3dcrtM2u_NH_",
  web_SECRET_KEY: "6LdVAxkTAAAAAHBO45vG52ZMogoakzo4wopvuLke"
};

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
//end group payment app



app.use(express.static('www'));
app.all('/*', function (req, res, next) {
  res.sendfile('index.html', { root: __dirname + '/www' });
});

app.listen(configs.port); //the port you want to use
console.log('Livestar WEB V2 - App started at port :' + configs.port);