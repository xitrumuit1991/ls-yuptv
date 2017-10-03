#"use strict"
#route = ($stateProvider, GlobalConfig)->
#  $stateProvider
#  .state "base.profile.user-information",
#    url : "/user-information"
#    templateUrl : "/templates/profile/user-information.html"
#    controller : "ProfileUserInformationCtrl"
#
#route.$inject = ['$stateProvider', 'GlobalConfig']
#
#
#ctrl = ($rootScope,
#  UtilityService,
#  $scope, $timeout, $location,
#  $window, $state, $stateParams,  ApiService, $http,
#  GlobalConfig, $interval) ->
#  console.log 'profile user-information'
#
#
#
#
#ctrl.$inject = [
#  '$rootScope',
#  'UtilityService', '$scope', '$timeout', '$location',
#  '$window', '$state', '$stateParams',  'ApiService', '$http',
#  'GlobalConfig', '$interval'
#]
#angular
#.module("app")
#.config route
#.controller "ProfileUserInformationCtrl", ctrl
