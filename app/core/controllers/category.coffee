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
#  console.log 'CategoryCtrl coffee ', $stateParams.id
  $scope.id = $stateParams.id
  return $state.go 'base' unless $stateParams.id
  $scope.category = null
  $scope.listCategory = []

  $scope.pagination =
    page:0
    limit: 18
    total_item:0
    total_page:0
    pageOnChange:()->
      $scope.loadCategoryDetail()

  $scope.categoryClickFollowIdol = (item, indexRoom)->
    return unless item
    return UtilityService.notifyError('Vui lòng đăng nhập') unless $rootScope.user
    ApiService.followIdol {roomId:item.id}, (error, result)->
      return if error
      return UtilityService.notifyError(result.message)  if result and result.error
      UtilityService.notifySuccess(result.message) if result
      if $scope.category and $scope.category.Rooms and $scope.category.Rooms[indexRoom]
        $scope.category.Rooms[indexRoom].isFollow = true


  $scope.loadCategoryDetail = ()->
    param =
      categoryId: $stateParams.id
      page : $scope.pagination.page
      limit : $scope.pagination.limit
    ApiService.getListRoomInCategory param,(err, result)->
      return if err or !result
      console.log 'getListRoomInCategory', result
      $scope.category = result.category
      $scope.pagination.total_item = result.attr.total_item
      index = _.findIndex $scope.listCategory, {id : $scope.category.id}
      if index != -1
        $scope.category.backgroundNormal = $scope.listCategory[index].backgroundNormal


  ApiService.getListCategory {}, (err, result)->
    $scope.listCategory = result
    $scope.loadCategoryDetail()

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval','UtilityService'
]
angular
.module("app")
.config route
.controller "CategoryCtrl", ctrl
