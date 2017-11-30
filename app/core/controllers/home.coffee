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
  console.log 'home coffee '
  $scope.listCategory = []
  $scope.groupIdol = []

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

  ApiService.getListCategory({}, (err, result)->
    $scope.listCategory = result
    console.warn 'home list category', $scope.listCategory
  )
  ApiService.getHomeContent( {},(error, result)->
    return if error
    $scope.groupIdol = result
    console.log 'home group idol', result
  )


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'UtilityService'
]
angular
.module("app")
.config route
.controller "HomeCtrl", ctrl
