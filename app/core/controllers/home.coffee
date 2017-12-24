"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base",
    url : "/"
    views :
      "main@" :
        templateUrl : "/templates/home/home.html"
        controller : "HomeCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']

ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, UtilityService) ->
#  console.warn 'home coffee '
  $scope.listCategory = []
  $scope.groupIdol = []

  $scope.homeClickunFollowIdol = (item, idGroup, indexRoom)->
    return unless item
    return UtilityService.notifyError('Vui lòng đăng nhập') unless $rootScope.user
    ApiService.unFollowIdol {roomId:item.id}, (error, result)->
      return if error
      return UtilityService.notifyError(result.message)  if result and result.error
      UtilityService.notifySuccess(result.message) if result
      indexGroup = _.findIndex($scope.groupIdol, {id : idGroup})
      if indexGroup != -1 and $scope.groupIdol[indexGroup]
        if $scope.groupIdol[indexGroup].Rooms and $scope.groupIdol[indexGroup].Rooms[indexRoom]
          $scope.groupIdol[indexGroup].Rooms[indexRoom].isFollow = false

  $scope.homeClickFollowIdol = (item, idGroup, indexRoom)->
    return unless item
    return UtilityService.notifyError('Vui lòng đăng nhập') unless $rootScope.user
    ApiService.followIdol({roomId:item.id}, (error, result)->
      return if error
      return UtilityService.notifyError(result.message)  if result and result.error
      UtilityService.notifySuccess(result.message) if result
      indexGroup = _.findIndex($scope.groupIdol, {id : idGroup})
      if indexGroup != -1 and $scope.groupIdol[indexGroup]
        if $scope.groupIdol[indexGroup].Rooms and $scope.groupIdol[indexGroup].Rooms[indexRoom]
          $scope.groupIdol[indexGroup].Rooms[indexRoom].isFollow = true
    )

  ApiService.getListCategory {}, (err, result)->
    $scope.listCategory = result
#    console.warn 'home list category', $scope.listCategory
    ApiService.getHomeContent {},(error, result)->
      return if error or !result
#      console.log 'home group idol', result
      #lay backgroundNormal(icon) show ra
      _.map result, (item)->
        index = _.findIndex $scope.listCategory, {id : item.id}
        item.backgroundNormal = $scope.listCategory[index].backgroundNormal
      #order lai danh sach room theo category
      tmpGroupIdolHome = []
      _.map $scope.listCategory, (item)->
        index = _.findIndex result, {id : item.id}
        tmpGroupIdolHome.push(result[index]) if index != -1
      $scope.groupIdol = tmpGroupIdolHome
#      console.log '$scope.groupIdol',$scope.groupIdol
#      console.log 'tmpGroupIdolHome',tmpGroupIdolHome

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'UtilityService'
]
angular
.module("app")
.config route
.controller "HomeCtrl", ctrl
