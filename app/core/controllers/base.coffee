"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base",
    url : "/"
    views :
      "main@" :
        templateUrl : "/templates/home/home.html"
        controller : "BaseCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'base coffee '

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "BaseCtrl", ctrl
