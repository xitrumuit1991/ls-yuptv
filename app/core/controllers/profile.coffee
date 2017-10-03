"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.profile",
    url : "profile"
    views :
      "main@" :
        templateUrl : "/templates/profile/view.html"
        controller : "ProfileCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, UtilityService) ->

  $scope.tabActive = 'user-information'
  $scope.savedVideo =
    page : 0
    limit : 12
    items : []
    total_page : 0
    total_item:0

  $scope.getSavedVideo = ()->
    return UtilityService.notifyError('Không thể lấy danh sách video') if !$rootScope.user or !$rootScope.user.Room
    params =
      page : $scope.savedVideo.page
      limit : $scope.savedVideo.limit
      roomId: $rootScope.user.Room.id
    ApiService.getSavedVideo(params,(error, result)->
      return UtilityService.notifyError('Không thể lấy danh sách video') if error
      if result and result.error
        return UtilityService.notifyError(result.message)
      $scope.savedVideo.items = result.videos
      $scope.savedVideo.total_page = result.attr.total_page
      $scope.savedVideo.total_item = result.attr.total_item
    )

  $scope.tabVideoPageChange = ()->
    console.log '$scope.savedVideo.page',$scope.savedVideo.page
    $scope.getSavedVideo()



  $scope.changeTab = (tab)->
    $scope.tabActive = tab

  $scope.updateProfile = ()->
#    name optional	string
#    email optional	string
#    birthday optional	string
#    address optional	string
#    phone optional	string
#    gender optional	string
#    fbId optional	string
#    gpId optional	string
#    fbLink optional	string
#    twitterLink optional	string
    ApiService.updateUserProfile($rootScope.user,(error, result)->
      if error
        return UtilityService.notifyError(JSON.stringify(error))
      if result and result.error
        return UtilityService.notifyError( result.message )
      UtilityService.notifySuccess( 'Cập nhập tài khoản thành công')
      UtilityService.setUserLogged(result)
    )

  #call api here
  $scope.getSavedVideo()

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'UtilityService'
]
angular
.module("app")
.config route
.controller "ProfileCtrl", ctrl
