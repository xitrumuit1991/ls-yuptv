"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.register",
    url : "register"
    views :
      "main@" :
        templateUrl : "/templates/register/view.html"
        controller : "registerCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'register coffee '

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "registerCtrl", ctrl
