"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.room-detail",
    url : "room-detail/:id"
    views :
      "main@" :
        templateUrl : "/templates/room-detail/view.html"
        controller : "RoomDetailCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'RoomDetailCtrl coffee ',$stateParams.id
  id = $stateParams.id
  $scope.id = $stateParams.id
  $scope.item = {}
  $scope.giftList =
    items : []
    totalItems:0
    currentPage:0

  $scope.getRoomDetail = ()->
    ApiService.room.getRoomById {roomId : $scope.id },(err, result)->
      return if err
      $scope.item = result
      console.log 'getRoomById',$scope.item


  $scope.openLichDien = ()->
    param =
      item : $scope.item
    $rootScope.$emit 'open-lich-dien-room-detail', param

  $scope.openListGift = ()->
    param =
      items : $scope.giftList.items
      action : (item)->
        console.log 'click action', item
    $rootScope.$emit 'open-list-gift', param

  $scope.getListGift = ()->
    ApiService.room.giftList({page:0, limit:1000},(err, result)->
      return if err
      $scope.giftList.items = result.items
      console.log '$scope.giftList',$scope.giftList
    )

  $scope.getRoomDetail()
  $scope.getListGift()

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "RoomDetailCtrl", ctrl
