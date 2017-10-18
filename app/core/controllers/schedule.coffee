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
  GlobalConfig, $interval, UtilityService, $uibModal) ->
  d =  new Date()
  dd = new Date()
  dd.setDate(d.getDate()+1)
  $scope.textNowDate = "Hôm nay, #{d.getDate()} tháng #{d.getMonth()+1}, #{d.getFullYear()}"
  $scope.textTomorrowDate = "Ngày mai, #{dd.getDate()} tháng #{dd.getMonth()+1}, #{dd.getFullYear()}"

  $scope.roomAtNowDate = []
  $scope.roomAtTomorrowDate = []
  $scope.activeView = 'now-tomorrow'
  $scope.listRoomSearch = []

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

  getListRoomFollow = ()->
    ApiService.getUserFollowing {},(error, result)->
      return if error
      return if result and result.error
      $scope.listUserFollowing = result.rooms

  getDataRoom = (type='now' , filter = false)->
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
      if filter == true
        $scope.activeView = 'filter-search'
        $scope.listRoomSearch = result
      else
        $scope.activeView = 'now-tomorrow'
        $scope.roomAtNowDate = result if type == 'now'
        $scope.roomAtTomorrowDate = result if type == '+1day'


  $scope.actionFollowRoom = (item)->
    paramFollow =
      roomId : item.Room.id
    ApiService.followIdol( paramFollow , (error, result)->
      return if error
      return if result and result.error
      UtilityService.notifySuccess(result.message)
      getListRoomFollow()
      if $scope.activeView == 'now-tomorrow'
        getDataRoom('now', false)
        getDataRoom('+1day', false)
    )

  $scope.changeCategorySelect = ()->
    $scope.activeView = 'filter-search'
    $scope.listRoomSearch = []

  $scope.changeDateSelect = ()->
    $scope.activeView = 'filter-search'
    $scope.monthSelected = ''
    if $scope.monthSelected == '' and $scope.dateSelected == ''
      getDataRoom('now', false)
      getDataRoom('+1day', false)
      return
    getDataRoom($scope.dateSelected, true)

  $scope.changeMonthSelect = ()->
    $scope.activeView = 'filter-search'
    $scope.dateSelected = ''
    if $scope.monthSelected == '' and $scope.dateSelected == ''
      getDataRoom('now', false)
      getDataRoom('+1day', false)
      return
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
      $scope.listRoomSearch = result
#      if result and result.length <= 0
#        return UtilityService.notifyError('Không có lịch diễn')

  $scope.onItemClick = (item, index)->
    i=0
    while i<$scope.listUserFollowing.length
      $scope.listUserFollowing[i].active = false if i != index
      $scope.listUserFollowing[index].active = true if i == index
      i++
    $uibModal.open({
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
    $uibModal.open({
      templateUrl: '/templates/schedule/schedule-modal-detail.html'
      backdrop: true
      windowClass: 'modal'
      controller: 'ScheduleModalDetailController'
      resolve: {
        modalItem: item.Room
      }
    })




  ApiService.getListCategory {},(error, result)->
    return if error
    return console.error(result) if result and result.error
    $scope.selectCategoryValue = result
    $scope.selectCategoryValue.unshift({ id:'', title : '----------' })

  getListRoomFollow()
  getDataRoom('now' , false)
  getDataRoom('+1day', false)


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams', 'ApiService', '$http',
  'GlobalConfig', '$interval' , 'UtilityService', '$uibModal'
]
angular
.module("app")
.config route
.controller "ScheduleCtrl", ctrl
