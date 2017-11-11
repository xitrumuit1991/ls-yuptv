"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.category",
    url : "category/:id"
    views :
      "main@" :
        templateUrl : "/templates/category/view.html"
        controller : "CategoryCtrl"
route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'CategoryCtrl coffee ', $stateParams.id
  $scope.id = $stateParams.id
  return $state.go 'base' unless $stateParams.id

  $scope.category = {}
  ApiService.getListRoomInCategory {categoryId: $stateParams.id},(err, result)->
    console.log 'getListRoomInCategory', result
    $scope.category = result.category


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "CategoryCtrl", ctrl
