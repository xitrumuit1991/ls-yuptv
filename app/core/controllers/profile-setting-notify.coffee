"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.profile.setting-notify",
    url : "/setting-notify"
    templateUrl : "/templates/profile/setting-notify.html"
    controller : "ProfileSettingNotifyCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'ProfileSettingNotifyCtrl coffee '
  $timeout(()->
    $(()->
#      $('#toggle-one').bootstrapToggle();
      $('#toggle-one').bootstrapToggle('on')
      $('#toggle-two').bootstrapToggle('off');
      $('#toggle-three').bootstrapToggle();
    )
  ,1)

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "ProfileSettingNotifyCtrl", ctrl
