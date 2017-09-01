"use strict"
angular.module('app').filter('convertDateFormat', ()->
    (date)->
        return '' unless date
        d = new Date(date);
        txtDate = d.getDate()
        if parseInt(txtDate) < 10
            txtDate = '0' + txtDate
        txtMonth = d.getMonth() + 1
        if parseInt(txtMonth) < 10
            txtMonth = '0' + txtMonth
        txtYear = d.getFullYear()
        return (txtDate + '-' + txtMonth + '-' + txtYear)
);

angular.module('app').filter('convertDateTimeFormat', ()->
    (date)->
        return '' unless date
        d = new Date(date);
        txtDate = d.getDate()
        if parseInt(txtDate) < 10
            txtDate = '0' + txtDate
        txtMonth = d.getMonth() + 1
        if parseInt(txtMonth) < 10
            txtMonth = '0' + txtMonth
        txtYear = d.getFullYear()

        txtHour = d.getHours()
        if parseInt(txtHour) < 10
            txtHour = '0' + txtHour
        txtMinutes = d.getMinutes()
        if parseInt(txtMinutes) < 10
            txtMinutes = '0' + txtMinutes

        txtSecond = d.getSeconds()
        if parseInt(txtSecond) < 10
            txtSecond = '0' + txtSecond

        return (txtHour + ':' + txtMinutes + ':' + txtSecond + ' ' + txtDate + '/' + txtMonth + '/' + txtYear)
);