"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.bang-xep-hang",
    url : "top-rank"
    views :
      "main@" :
        templateUrl : "/templates/bang-xep-hang/view.html"
        controller : "BangXepHangCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']

ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'BangXepHangCtrl coffee '
  $scope.tab = 'top-yeu-thich'

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "BangXepHangCtrl", ctrl
