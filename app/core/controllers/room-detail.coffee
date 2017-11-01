"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.room-detail",
    url : "room-detail/:id"
    views :
      "main@" :
        templateUrl : "/templates/room-detail/view.html"
        controller : "RoomDetailCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'RoomDetailCtrl coffee ',$stateParams.id
  id = $stateParams.id

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "RoomDetailCtrl", ctrl
