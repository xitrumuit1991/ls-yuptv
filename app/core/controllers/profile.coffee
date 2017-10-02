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

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'UtilityService'
]
angular
.module("app")
.config route
.controller "ProfileCtrl", ctrl
