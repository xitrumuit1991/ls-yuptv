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
  $scope.rankCoin = []
  $scope.rankHeart = []
  $scope.rankFacebook = []

  ApiService.getRankCoin({},(error, result)->
    return if error
    $scope.rankCoin = result
  )
  ApiService.getRankHeart({},(error, result)->
    return if error
    $scope.rankHeart = result
  )
  ApiService.getRankShareFacebook({},(error, result)->
    return if error
    $scope.rankFacebook = result
  )

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "BangXepHangCtrl", ctrl
