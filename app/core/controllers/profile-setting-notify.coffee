"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.profile.setting-notify",
    url : "/setting-notify"
    templateUrl : "/templates/profile/setting-notify.html"
    controller : "ProfileSettingNotifyCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  UtilityService,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'ProfileSettingNotifyCtrl coffee '

  $scope.changeSetting = (type , checked)->
    onOff = if checked then 'on' else 'off'
    UtilityService.setSettingNotify(type,onOff)

  $timeout(()->
    $(()->
      if UtilityService.getSettingNotify('live-notification') == 'on'
        $('#toggle-one').bootstrapToggle('on')
      else
        $('#toggle-one').bootstrapToggle('off')

      if UtilityService.getSettingNotify('schedule-notification') == 'on'
        $('#toggle-two').bootstrapToggle('on')
      else
        $('#toggle-two').bootstrapToggle('off')

      if UtilityService.getSettingNotify('birthday-notification') == 'on'
        $('#toggle-three').bootstrapToggle('on');
      else
        $('#toggle-three').bootstrapToggle('off');

      fnChangeSetting = ()->
        checked = $(this).prop('checked')
        type = $(this).attr('notify-type');
        $scope.changeSetting(type, checked)
      $('#toggle-one').change(fnChangeSetting)
      $('#toggle-two').change(fnChangeSetting)
      $('#toggle-three').change(fnChangeSetting)
    )
  ,1)

ctrl.$inject = [
  '$rootScope',
  'UtilityService', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "ProfileSettingNotifyCtrl", ctrl
