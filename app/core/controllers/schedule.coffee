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

  $scope.selectCategoryValue = []
  $scope.categorySelected = ''
#  $scope.categorySelected = '9ac8fc48-86f2-11e7-b556-0242ac110005' #all

  $scope.selectDateValue = [
    {id:'', title:'----------'},
    {id:'-3day', title:'3 Ngày Trước'},
    {id:'now', title:'Hôm Nay'},
    {id:'+1day', title:'Ngày mai'},
    {id:'+3day', title:'3 Ngày Sau'},
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

  ApiService.getListCategory({},(error, result)->
    return if error
    return console.error(result) if result and result.error
    $scope.selectCategoryValue = result
    console.log '$scope.selectCategoryValue',$scope.selectCategoryValue
    $scope.selectCategoryValue.unshift({
      id:'',
      title : '----------'
    })
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
