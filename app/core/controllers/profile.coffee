"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.profile",
    url : "profile"
    views :
      "main@" :
        templateUrl : "/templates/profile/view.html"
        controller : "ProfileCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->

  $scope.tabActive = 'user-information'
  $scope.changeTab = (tab)->
    $scope.tabActive = tab

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "ProfileCtrl", ctrl
