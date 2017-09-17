"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.policy",
    url : "policy"
    views :
      "main@" :
        templateUrl : "/templates/policy/view.html"
        controller : "PolicyCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'policy coffee '

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "PolicyCtrl", ctrl
