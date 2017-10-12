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
  GlobalConfig, $interval)->

  return
ctrl.$inject = [ '$rootScope', 'UtilityService', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "ProfileManageRoomCtrl", ctrl
