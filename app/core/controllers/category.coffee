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
  GlobalConfig, $interval, UtilityService) ->
  console.log 'CategoryCtrl coffee ', $stateParams.id
  $scope.id = $stateParams.id
  return $state.go 'base' unless $stateParams.id
  $scope.category = null
  $scope.listCategory = []



  $scope.categoryClickFollowIdol = (item, indexRoom)->
    return unless item
    return UtilityService.notifyError('Vui lòng đăng nhập') unless $rootScope.user
    ApiService.followIdol {roomId:item.id}, (error, result)->
      return if error
      return UtilityService.notifyError(result.message)  if result and result.error
      UtilityService.notifySuccess(result.message) if result
      if $scope.category and $scope.category.Rooms and $scope.category.Rooms[indexRoom]
        $scope.category.Rooms[indexRoom].isFollow = true


  ApiService.getListRoomInCategory {categoryId: $stateParams.id},(err, result)->
    console.log 'getListRoomInCategory', result
    $scope.category = result.category

    ApiService.getListCategory {}, (err, result)->
      $scope.listCategory = result
      index = _.findIndex $scope.listCategory, {id : $scope.category.id}
      if index != -1
        $scope.category.backgroundNormal = $scope.listCategory[index].backgroundNormal


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval','UtilityService'
]
angular
.module("app")
.config route
.controller "CategoryCtrl", ctrl
