"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.about-us",
    url : "about-us"
    views :
      "main@" :
        templateUrl : "/templates/aboutUs/view.html"
        controller : "AboutUsCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'aboutUs coffee '

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "AboutUsCtrl", ctrl
