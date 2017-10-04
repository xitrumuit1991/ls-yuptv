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
  GlobalConfig, $interval, UtilityService) ->
  console.log 'BangXepHangCtrl coffee '
  $scope.tab = 'top-yeu-thich'
  $scope.rankCoin = []
  $scope.rankHeart = []
  $scope.rankFacebook = []

  $scope.followIdol = (type, item)->
    if type == 'heart'
      roomId = item.User.Room.id
      return unless roomId
      ApiService.followIdol({roomId:roomId}, (error, result)->
        return if error
        return if result and result.error
        UtilityService.notifySuccess(result.message)
        index  = _.findIndex($scope.rankHeart, {id: item.id})
        $scope.rankHeart[index].User.Room.isFollow = true if index != -1
      )
      return
    if type == 'coin'
      roomId = item.User.Room.id
      return unless roomId
      ApiService.followIdol({roomId:roomId}, (error, result)->
        return if error
        return if result and result.error
        UtilityService.notifySuccess(result.message)
        index  = _.findIndex($scope.rankCoin, {id: item.id})
        $scope.rankCoin[index].User.Room.isFollow = true if index != -1
      )
      return
    if type == 'facebook'
      roomId = item.User.Room.id
      return unless roomId
      ApiService.followIdol({roomId:roomId}, (error, result)->
        return if error
        return if result and result.error
        UtilityService.notifySuccess(result.message)
        index  = _.findIndex($scope.rankFacebook, {id: item.id})
        $scope.rankFacebook[index].User.Room.isFollow = true if index != -1
      )
      return



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
  'GlobalConfig', '$interval' , 'UtilityService'
]
angular
.module("app")
.config route
.controller "BangXepHangCtrl", ctrl
