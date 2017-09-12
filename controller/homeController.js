var request = require('request');
var async = require('async');
var underscore = require('underscore');

var layout = 'layout';

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

var homeController = {};
homeController.getViewHome = function (req,res)
{
  return res.render('home/index',
    {
      user:req.session.user,
      token:req.session.token,
      layout:layout
    });
};

module.exports = homeController;