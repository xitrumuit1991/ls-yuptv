"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.schedule",
    url : "lich-dien"
    views :
      "main@" :
        templateUrl : "/templates/schedule/view.html"
        controller : "ScheduleCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']

ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams, ApiService, $http,
  GlobalConfig, $interval, UtilityService) ->
  d =  new Date()
  dd = new Date()
  dd.setDate(d.getDate()+1)
  $scope.textNowDate = "Hôm nay, #{d.getDate()} tháng #{d.getMonth()+1}, #{d.getFullYear()}"
  $scope.textTomorrowDate = "Ngày mai, #{dd.getDate()} tháng #{dd.getMonth()+1}, #{dd.getFullYear()}"

  $scope.roomAtNowDate = []
  $scope.roomAtTomorrowDate = []

  $scope.selectCategory = []
  $scope.listUserFollowing = []

  ApiService.getListCategory({},(error, result)->
    return if error
    return console.error(result) if result and result.error
    $scope.selectCategory = result
    console.log $scope.selectCategory
  )

  getDataRoom = (type='now')->
    paramNowDate=
      keyword	: ''
      type : 'day'
    if type == 'now'
      paramNowDate.time = UtilityService.getMiliSecBeginDay('now')
    if type == '+1day'
      paramNowDate.time = UtilityService.getMiliSecBeginDay('+1day')
    ApiService.getListRoomSchedule(paramNowDate, (error, result)->
      return if error
      return console.error(result) if result and result.error
      $scope.roomAtNowDate = result if type == 'now'
      $scope.roomAtTomorrowDate = result if type == '+1day'
    )


  getDataRoom('now')
  getDataRoom('+1day')
  ApiService.getUserFollowing({},(error, result)->
    return if error
    return if result and result.error
    $scope.listUserFollowing = result.rooms
  )

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams', 'ApiService', '$http',
  'GlobalConfig', '$interval' , 'UtilityService'
]
angular
.module("app")
.config route
.controller "ScheduleCtrl", ctrl
