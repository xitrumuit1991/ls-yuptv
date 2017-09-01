var express = require('express');
var app = express();
var port = 1400;
app.use(express.static('www'));

app.get('/health_check', function (req, res) {
  res.json({service : 'ls web v2', time : (new Date()).getTime(), message : 'ok' })
});

app.all('/*', function (req, res, next) {
  res.sendfile('index.html', { root: __dirname + '/www' });
});

app.listen(port); //the port you want to use
console.log('WEB V2 - App started at port :' + port);