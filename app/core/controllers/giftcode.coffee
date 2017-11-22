"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.giftcode",
    url : "nhangiftcode"
    views :
      "main@" :
        templateUrl : "/templates/giftcode/view.html"
        controller : "nhangiftcode.Ctrl"
route.$inject = ['$stateProvider', 'GlobalConfig']
ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'nhangiftcode coffee '

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "nhangiftcode.Ctrl", ctrl
