"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.profile.manage-room",
    url : "/manage-room"
    templateUrl : "/templates/profile/manage-room.html"
    controller : "ProfileManageRoomCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']

ctrl = ($rootScope, UtilityService, $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, $uibModal, Upload)->
  $scope.scheduleDate =
    dt : null
    opened : false

  $scope.listScheduleOfRoom = []
  $scope.selectCategoryValue = []
  $scope.categorySelected = $rootScope.user.Room.categoryId

  $scope.onChangeCategoryRoom = ()->
    console.log 'categorySelected',$scope.categorySelected
    ApiService.room.changeCategory {categoryId:$scope.categorySelected}, (error, result)->
      return if error
      return UtilityService.notifyError(result.message) if result and result.error
      UtilityService.notifySuccess('Thay đổi danh mục thành công')


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

  $scope.changeMonthSelect = ()->


  getScheduleOfRoom = ()->
    param =
      type : 'all'
      roomId : $rootScope.user.Room.id
    ApiService.getScheduleOfRoom(param,(error, result)->
      return if error
      return if result and result.error
      console.log 'getScheduleOfRoom',result
      $scope.listScheduleOfRoom = result
    )

  $scope.deleteItemSchedule = (item)->
    return unless confirm('Bạn có chắc muốn xoá')
    console.log 'deleteItemSchedule', item
    ApiService.deleteSchedule({scheduleId:item.id}, (error,result)->
      return if error
      return if result and result.error
      UtilityService.notifySuccess('Xoá thành công')
      getScheduleOfRoom()
    )


  $scope.openModalDetailAddEdit = (item=null)->
    console.log 'openScheduleDetail', item
    if item == null
      item =
        callback : getScheduleOfRoom
    else
      item.callback = getScheduleOfRoom
    $uibModal.open({
      templateUrl: '/templates/profile/modal-manage-room.html'
      backdrop: true
      windowClass: 'modal'
      controller: 'ModalManageRoomController'
      resolve: {
        modalItem: item
      }
    })


  $scope.changeRoomBanner = (file, errFiles)->
    console.log 'fileSelect=',file
    console.log 'errFiles=',errFiles
    console.log 'errFiles[0]=',errFiles[0]
    if errFiles and errFiles[0]
      return UtilityService.notifyError( "ERROR: #{errFiles[0].$error} #{errFiles[0].$errorParam}" )
    if file
      file.upload = Upload.upload({
        url : GlobalConfig.API_URL + 'room/banner'
        data : {banner : file}
        method : 'POST'
      })
      file.upload.then ((response) ->
        console.log 'response',response
        if response and response.status == 200
          UtilityService.notifySuccess('Thay đổi thành công')
          ApiService.getProfile {},(error, result)->
            return if error
            UtilityService.setUserProfile(result) if result
            return
        return
      ), ((response) ->
        console.log 'response',response
        UtilityService.notifyError("#{response.status} : #{response.statusText}" )
        return
      ), (evt) ->
        console.log 'evt.loaded',evt.loaded
        console.log 'evt.total',evt.total
        #        file.progress = Math.min(100, parseInt(100.0 * evt.loaded / evt.total))
        return
    return


  ApiService.getListCategory {},(error, result)->
    return if error
    return console.error(result) if result and result.error
    $scope.selectCategoryValue = result


  getScheduleOfRoom()


  return
ctrl.$inject = [ '$rootScope', 'UtilityService', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval' , '$uibModal' ,'Upload'
]
angular
.module("app")
.config route
.controller "ProfileManageRoomCtrl", ctrl
