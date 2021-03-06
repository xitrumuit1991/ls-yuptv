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
  $scope.activeView = 'now-tomorrow'
  $scope.textResultTimKiem = ''
  $scope.roomAtNowDate = []
  $scope.roomAtTomorrowDate = []

  $scope.listRoomSearch = []
  $scope.items = []

  $scope.selectCategoryValue = []
  $scope.categorySelected = ''

  $scope.selectDateValue = [
    {id:'', title:'---Chọn---'},
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
    {id:'', title:'---Chọn---'},
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

  $scope.pagination =
    page : 1
    limit : 10
    total_item : 0
    filterSearchPageOnChange:()->
      start = ($scope.pagination.page-1)*$scope.pagination.limit
      end = ($scope.pagination.page-1)*$scope.pagination.limit + $scope.pagination.limit
      $scope.items = []
      i = start
      while i < end and i <= $scope.pagination.total_item
        $scope.items.push($scope.listRoomSearch[i])
        i++
      console.log '$scope.pagination.page',$scope.pagination.page
      console.log '$scope.items',$scope.items
      console.log 'start',start
      console.log 'end',end

  $scope.param =
    keyword	: ''
    type : 'day'
    time : ''
    page : $scope.pagination.page
    limit : $scope.pagination.limit

  getListRoomFollow = ()->
    ApiService.getUserFollowing {},(error, result)->
      return if error or !result
      return if result and result.error
      $scope.listUserFollowing = result.rooms

  getDataRoom = (type='now' , filter = false)->
    $scope.param.type = 'day' if type in ['now', '0day', 'day', '+1day' , '-1day']
    $scope.param.type = 'day3' if type in ['+3day', '-3day']
    $scope.param.type = 'week' if type in ['+7day', '-7day']
    $scope.param.type = 'month' if type in ['+30day', '-30day']
    $scope.param.time = UtilityService.getMiliSecBeginDay(type)
    ApiService.getListRoomSchedule $scope.param, (error, result)->
      return console.error(result) if error or !result
      return console.error(result) if result and result.error
      if filter == true
        $scope.activeView = 'filter-search'
        $scope.listRoomSearch = result
        $scope.pagination.total_item = result.length if result
        $scope.pagination.filterSearchPageOnChange()
      else
        $scope.activeView = 'now-tomorrow'
        $scope.roomAtNowDate = result if type == 'now'
        $scope.roomAtTomorrowDate = result if type == '+1day'


  $scope.lichdienFollowRoom = (item, type="follow")->
    return UtilityService.notifyError('Vui lòng đăng nhập ') unless $rootScope.user
    if type == 'follow'
      ApiService.followIdol {roomId : item.Room.id} , (error, result)->
        return if error
        return if result and result.error
        UtilityService.notifySuccess(result.message)
        item.Room.isFollow = !item.Room.isFollow
        getListRoomFollow()
        if $scope.activeView == 'now-tomorrow'
          getDataRoom('now', false)
          getDataRoom('+1day', false)
    if type == 'unfollow'
      ApiService.unFollowIdol {roomId : item.Room.id} , (error, result)->
        return if error
        return if result and result.error
        UtilityService.notifySuccess(result.message)
        item.Room.isFollow = !item.Room.isFollow
        getListRoomFollow()
        if $scope.activeView == 'now-tomorrow'
          getDataRoom('now', false)
          getDataRoom('+1day', false)

  $scope.getTextTimKiem =()->
    if $scope.categorySelected
      _.map $scope.selectCategoryValue, (item)->
        if  item.id and item.id == $scope.categorySelected
          $scope.textResultTimKiem = item.title
    if $scope.monthSelected
      _.map $scope.selectMonthValue, (item)->
        if item.id and item.id == $scope.monthSelected
          $scope.textResultTimKiem = item.title
    if $scope.dateSelected
      _.map $scope.selectDateValue, (item)->
        if item.id  and item.id == $scope.dateSelected
          $scope.textResultTimKiem = item.title

  $scope.changeCategorySelect = ()->
    $scope.activeView = 'filter-search'
    $scope.listRoomSearch = []
    $scope.getTextTimKiem()
    $scope.pagination.page = 1

  $scope.changeDateSelect = ()->
    $scope.activeView = 'filter-search'
    $scope.monthSelected = ''
    if $scope.monthSelected == '' and $scope.dateSelected == ''
      getDataRoom('now', false)
      getDataRoom('+1day', false)
      return
    $scope.pagination.page = 1
    getDataRoom($scope.dateSelected, true)
    $scope.getTextTimKiem()

  $scope.changeMonthSelect = ()->
    $scope.activeView = 'filter-search'
    $scope.dateSelected = ''
    if $scope.monthSelected == '' and $scope.dateSelected == ''
      getDataRoom('now', false)
      getDataRoom('+1day', false)
      return
    $scope.pagination.page = 1
    $scope.getTextTimKiem()
    d = new Date()
    d.setDate(1)
    d.setMonth( parseInt($scope.monthSelected)-1 )
    d.setHours(0)
    d.setMinutes(0)
    d.setSeconds(0)
    d.setMilliseconds(0)
    d.setTime( d.getTime() - d.getTimezoneOffset()*60*1000 )
    $scope.param.keyword = ''
    $scope.param.type = 'month'
    $scope.param.time = Math.floor(d.getTime()/1000)
    ApiService.getListRoomSchedule $scope.param, (error, result)->
      return console.error(result) if error
      return console.error(result) if result and result.error
      $scope.listRoomSearch = result

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
    $scope.selectCategoryValue.unshift({ id:'', title : '---Chọn---' })

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
