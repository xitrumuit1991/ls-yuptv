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
  GlobalConfig, $interval, UtilityService, Upload) ->
  $scope.birthDate =
    dt : if $rootScope.user then new Date($rootScope.user.birthday) else (new Date())
    opened :  false
    min : new Date()

  $scope.openDate = () ->
    $timeout () ->
      $scope.birthDate.opened = true;


  $scope.changePass =
    old : ''
    new : ''
    renew : ''
  $scope.tabActive = 'user-information'
  $scope.savedVideo =
    page : 0
    limit : 12
    items : []
    total_page : 0
    total_item:0

  $scope.following =
    page : 0
    limit : 12
    items : []
    total_page : 0
    total_item:0

  $scope.follower =
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
    $scope.getSavedVideo()




  $scope.getFollowing = ()->
    return UtilityService.notifyError('Không thể lấy danh sách đang theo dõi ') if !$rootScope.user
    params =
      page : $scope.following.page
      limit : $scope.following.limit
      userId: $rootScope.user.id
    ApiService.getUserFollowing params,(error, result)->
      return UtilityService.notifyError('Không thể lấy danh sách đang theo dõi') if error
      if result and result.error
        return UtilityService.notifyError(result.message)
      console.log 'getFollowing result', result
      $scope.following.items = result.rooms
      $scope.following.total_page = result.attr.total_page
      $scope.following.total_item = result.attr.total_item

  $scope.tabFollowingPageChange = ()->
    $scope.getFollowing()




  $scope.getFollower = ()->
    return UtilityService.notifyError('Không thể lấy danh sách người theo dõi ') if !$rootScope.user
    params =
      page : $scope.follower.page
      limit : $scope.follower.limit
      userId: $rootScope.user.id
    ApiService.getUserFollower params,(error, result)->
      return UtilityService.notifyError('Không thể lấy danh sách người theo dõi') if error
      if result and result.error
        return UtilityService.notifyError(result.message)
      $scope.follower.items = result.rooms
      $scope.follower.total_page = result.attr.total_page
      $scope.follower.total_item = result.attr.total_item

  $scope.tabFollowerPageChange = ()->
    $scope.getFollower()



  $scope.changeTab = (tab)->
    $scope.tabActive = tab


  $scope.uploadNewAvatar = (file, errFiles)->
    console.log 'fileSelect=',file
    console.log 'errFiles=',errFiles
    console.log 'errFiles[0]=',errFiles[0]
    if errFiles and errFiles[0]
      return UtilityService.notifyError( "ERROR: #{errFiles[0].$error} #{errFiles[0].$errorParam}" )
    if file
      file.upload = Upload.upload({
        url : GlobalConfig.API_URL + 'user/avatar'
        data : {avatar : file}
        method : 'PUT'
      })
      file.upload.then ((response) ->
        console.log 'response',response
        if response and response.status == 200
          UtilityService.notifySuccess('Thay đổi ảnh đại diện thành công')
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


  $scope.updateProfile = ()->
    if $scope.changePass.old
      console.log 'change pass'
      if !$scope.changePass.new or !$scope.changePass.renew
        return UtilityService.notifyError('Vui lòng nhập mật khẩu mới ')
      return UtilityService.notifyError('Mật khẩu ít nhất 6 kí tự') if $scope.changePass.new.length < 6
      if $scope.changePass.new != $scope.changePass.renew
        return UtilityService.notifyError('Mật khẩu xác nhận không đúng ')
      paramsPass=
        password : $scope.changePass.old
        new_password : $scope.changePass.new
        flush_token:false
      ApiService.changePassword(paramsPass,(error, result)->
        if error
          return UtilityService.notifyError(JSON.stringify(error))
        if result and result.error
          return UtilityService.notifyError( result.message )
        $rootScope.user.birthday = $scope.birthDate.dt
        ApiService.updateUserProfile($rootScope.user,(error, result)->
          if error
            return UtilityService.notifyError(JSON.stringify(error))
          if result and result.error
            return UtilityService.notifyError( result.message )
          UtilityService.notifySuccess( 'Cập nhập tài khoản thành công')
          UtilityService.setUserProfile(result)
        )
      )
      return
    return UtilityService.notifyError( 'Vui lòng nhập mật khẩu hiện tại') if $scope.changePass.new or $scope.changePass.renew
    $rootScope.user.birthday = $scope.birthDate.dt
    ApiService.updateUserProfile($rootScope.user,(error, result)->
      if error
        return UtilityService.notifyError(JSON.stringify(error))
      if result and result.error
        return UtilityService.notifyError( result.message )
      UtilityService.notifySuccess( 'Cập nhập tài khoản thành công')
      UtilityService.setUserProfile(result)
    )

  #call api here
  $scope.getSavedVideo()
  $scope.getFollowing()
  $scope.getFollower()

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'UtilityService' , 'Upload'
]
angular
.module("app")
.config route
.controller "ProfileCtrl", ctrl
