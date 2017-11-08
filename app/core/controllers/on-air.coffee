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
  GlobalConfig, $interval, UtilityService) ->

  $scope.categorySelected = null
  $scope.items = []
  $scope.categorys = []

  $scope.selectCategory = (item, index)->
    $scope.categorySelected = item
    if item.id =='9ac8fc48-86f2-11e7-b556-0242ac110005'
      $scope.loadData()
      return
    param =
      onair : true
      categoryId : item.id
    ApiService.onAirByCategory(param, (err, result)->
      return if err
      result if result and result.error
      $scope.items = if result and result.category then result.category.Rooms else []
    )

  $scope.loadData = ()->
#    ApiService.onAirByCategory({onair : true, categoryId : '9ac8fc48-86f2-11e7-b556-0242ac110005'},(err, result)->
    ApiService.onAir({onair : true },(err, result)->
      return if err
      return UtilityService.notifyError(result.message) if result and result.error
      $scope.items = result.rooms
    )
  $scope.loadCategory = ()->
    ApiService.getCategory({},(err, result)->
      return if err
      return UtilityService.notifyError(result.message) if result and result.error
      $scope.categorys = result
    )

  $scope.loadData()
  $scope.loadCategory()


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'UtilityService'
]
angular
.module("app")
.config route
.controller "OnAirCtrl", ctrl
