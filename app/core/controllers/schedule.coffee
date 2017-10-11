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
  GlobalConfig, $interval, UtilityService, $modal) ->
  d =  new Date()
  dd = new Date()
  dd.setDate(d.getDate()+1)
  $scope.textNowDate = "Hôm nay, #{d.getDate()} tháng #{d.getMonth()+1}, #{d.getFullYear()}"
  $scope.textTomorrowDate = "Ngày mai, #{dd.getDate()} tháng #{dd.getMonth()+1}, #{dd.getFullYear()}"

  $scope.roomAtNowDate = []
  $scope.roomAtTomorrowDate = []

  $scope.selectCategoryValue = []
  $scope.categorySelected = ''

  $scope.selectDateValue = [
    {id:'', title:'----------'},
    {id:'-7day', title:'Tuần Trước'},
    {id:'-3day', title:'3 Ngày Trước'},
    {id:'-1day', title:'Hôm Trước'},
    {id:'now',    title:'Hôm Nay'},
    {id:'+1day', title:'Ngày mai'},
    {id:'+3day', title:'3 Ngày Sau'},
    {id:'+7day', title:'Tuần Sau'},
  ]
  $scope.dateSelected = ''

  $scope.selectMonthValue = [
    {id:'', title:'----------'},
    {id:'1', title:'Tháng 1'},
    {id:'2', title:'Tháng 2'},
    {id:'3', title:'Tháng 3'},
    {id:'4', title:'Tháng 4'},
    {id:'5', title:'Tháng 5'},
    {id:'6', title:'Tháng 6'},
    {id:'7', title:'Tháng 7'},
    {id:'8', title:'Tháng 8'},
    {id:'9', title:'Tháng 9'},
    {id:'10', title:'Tháng 10'},
    {id:'11', title:'Tháng 11'},
    {id:'12', title:'Tháng 12'},
  ]
  $scope.monthSelected = ''

  $scope.listUserFollowing = []

  getDataRoom = (type='now')->
    paramNowDate=
      keyword	: ''
      type : 'day'
      time : ''
    paramNowDate.type = 'day' if type in ['now', '0day', 'day', '+1day' , '-1day']
    paramNowDate.type = 'day3' if type in ['+3day', '-3day']
    paramNowDate.type = 'week' if type in ['+7day', '-7day']
    paramNowDate.type = 'month' if type in ['+30day', '-30day']
    paramNowDate.time = UtilityService.getMiliSecBeginDay(type)
    ApiService.getListRoomSchedule paramNowDate, (error, result)->
      return console.error(result) if error
      return console.error(result) if result and result.error
#      return UtilityService.notifyError('Không có lịch diễn') if result and result.length <= 0
      $scope.roomAtNowDate = result if type == 'now'
      $scope.roomAtTomorrowDate = result if type == '+1day'


  $scope.changeCategorySelect = ()->
    console.log '$scope.categorySelected',$scope.categorySelected
    console.log '$scope.dateSelected',$scope.dateSelected
    console.log '$scope.monthSelected',$scope.monthSelected

  $scope.changeDateSelect = ()->
    getDataRoom($scope.dateSelected)

  $scope.changeMonthSelect = ()->
    $scope.dateSelected = ''
    d = new Date()
    d.setDate(1)
    d.setMonth( parseInt($scope.monthSelected)-1)
    d.setHours(0)
    d.setMinutes(0)
    d.setSeconds(0)
    d.setMilliseconds(0)
    paramNowDate=
      keyword	: ''
      type : 'month'
      time : (d.getTime()/1000)
    ApiService.getListRoomSchedule paramNowDate, (error, result)->
      return console.error(result) if error
      return console.error(result) if result and result.error
      return UtilityService.notifyError('Không có lịch diễn') if result and result.length <= 0

  $scope.onItemClick = (item, index)->
    console.log 'click scheduleOfRoom', item
    i=0
    while i<$scope.listUserFollowing.length
      $scope.listUserFollowing[i].active = false if i != index
      $scope.listUserFollowing[index].active = true if i == index
      i++
    params =
      roomId : item.id
      type : 'all'
    ApiService.getScheduleOfRoom params, (error, result)->
      return console.error(result) if error
      return console.error(result) if result and result.error
      console.log 'scheduleOfRoom ',result
      $modal.open({
        templateUrl: '/templates/schedule/schedule-modal-detail.html'
        backdrop: true
        windowClass: 'modal'
        controller: 'ScheduleModalDetailController'
        resolve: {
          modalItem: item
        }
      })

  $scope.openScheduleDetail = (item)->
    console.log 'openScheduleDetail', item
    $modal.open({
      templateUrl: '/templates/schedule/schedule-modal-detail.html'
      backdrop: true
      windowClass: 'modal'
      controller: 'ScheduleModalDetailController'
      resolve: {
        modalItem: item.Room
      }
    })



  ApiService.getUserFollowing {},(error, result)->
    return if error
    return if result and result.error
    $scope.listUserFollowing = result.rooms
  ApiService.getListCategory {},(error, result)->
    return if error
    return console.error(result) if result and result.error
    $scope.selectCategoryValue = result
    console.log '$scope.selectCategoryValue',$scope.selectCategoryValue
    $scope.selectCategoryValue.unshift({ id:'', title : '----------' })

  getDataRoom('now')
  getDataRoom('+1day')


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams', 'ApiService', '$http',
  'GlobalConfig', '$interval' , 'UtilityService', '$modal'
]
angular
.module("app")
.config route
.controller "ScheduleCtrl", ctrl
