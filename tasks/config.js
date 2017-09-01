var local = {};
try {
  local = require('./local.js');
} catch (e) {
  console.log('Run without local file');
}
var config = {
  localPublic: 'www',
  PORT: process.env.PORT
    ? process.env.PORT
    : 1338,
  APP_SCRIPT: 'app.js',
  serverPath: '/',//'https://movies.fimplus.vn/tv/',
  prefix: function (data, prefix) {
    return data.map(function (path) {
      return prefix + '/' + path;
    });
  },
  cssfiles: [
    'css/normalize.css',
    'css/owl.carousel.css',
    'css/main.css'
  ],
  jsfiles: [
    'js/underscore.js',
    'js/jquery.js',
    'js/angular.js',
    'js/*',
    'js/templates.js',
    'core/authentication.js',
    'core/config.js',
    'core/app.js',
    'core/app*.js',
    'core/**/*.js',
    'pages/**/*.js'
  ]
};
for (var key in local) {
  config[key] = local[key];
}
module.exports = config;