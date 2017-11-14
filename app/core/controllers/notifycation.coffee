"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.notifycation",
    url : "notifycation"
    views :
      "main@" :
        templateUrl : "/templates/notifycation/view.html"
        controller : "NotifycationCtrl"
route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'notifycation coffee '
  $scope.pagination =
    page:0
    limit: 20
  $scope.items = []
  ApiService.notificationList $scope.pagination,(err, result)->
    console.log 'notificationList in notifycation coffee;  result ',result
    $scope.items = result.items


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "NotifycationCtrl", ctrl
