"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.on-air",
    url : "on-air"
    views :
      "main@" :
        templateUrl : "/templates/onAir/view.html"
        controller : "OnAirCtrl"
route.$inject = ['$stateProvider', 'GlobalConfig']
ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'OnAirCtrl coffee '

  $scope.categorySelected = null
  $scope.items = []
  $scope.categorys = []

  $scope.selectCategory = (item, index)->
    $scope.categorySelected = item
    if item.id =='9ac8fc48-86f2-11e7-b556-0242ac110005'
      ApiService.onAir {},(err, result)->
        return if err
        result if result and result.error
        $scope.items = result.rooms
        console.log 'on air $scope.items',$scope.items
      return
    param =
      onair : true
      categoryId : item.id
    ApiService.onAirByCategory(param, (err, result)->
      return if err
      result if result and result.error
      $scope.items = if result and result.category then result.category.Rooms else []
    )


  ApiService.onAir({},(err, result)->
    return if err
    result if result and result.error
    $scope.items = result.rooms
    console.log 'on air $scope.items',$scope.items
  )

  ApiService.getCategory({},(err, result)->
    return if err
    result if result and result.error
    $scope.categorys = result
  )

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "OnAirCtrl", ctrl
