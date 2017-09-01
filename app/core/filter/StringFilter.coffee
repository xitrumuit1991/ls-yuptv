"use strict"
angular.module('app').filter('LimitStringLength', ()->
  (text, length, end)->
    if (isNaN(length))
      length = 10;
    if (end is undefined)
      end = "...";
    if (text.length <= length || text.length - end.length <= length)
      return text;
    else
      return String(text).substring(0, length-end.length) + end;
);