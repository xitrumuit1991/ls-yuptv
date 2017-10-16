#quan ly tai san
"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.profile.manage-property",
    url : "/manage-property"
    templateUrl : "/templates/profile/manage-property.html"
    controller : "ProfileManagePropertyCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']

ctrl = ($rootScope, UtilityService, $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, $uibModal, Upload)->
  $scope.activeView = 'history-charged' #gift-received
  $scope.changeTab = (tab)->
    $scope.activeView = tab

  return
ctrl.$inject = [ '$rootScope', 'UtilityService', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval' , '$uibModal' ,'Upload'
]
angular
.module("app")
.config route
.controller "ProfileManagePropertyCtrl", ctrl
