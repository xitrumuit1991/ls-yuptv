angular.module('app').filter('ConverTime', ()->
  (second, format=null )->
    unless second
#      return '00:00:00'
      return ''
    if second > (48*60*60)
      date = Math.floor(second / 86400)
      return "còn #{date} ngày"
    totalSec = second
    hours = Math.floor(totalSec / 3600);
    totalSec = totalSec % 3600;
    minutes = Math.floor(totalSec / 60);
    seconds = Math.round(totalSec % 60);
    resText = ''
    if hours < 10
      resText = '0'+hours.toString()
    else
      resText = hours.toString()
    resText=resText+':'

    if minutes < 10
      resText=resText+'0'+minutes.toString()
    else
      resText=resText+minutes.toString()
    resText=resText+':'

    if seconds < 10
      resText=resText+'0'+seconds.toString()
    else
      resText=resText+seconds.toString()
    return resText.toString()
);