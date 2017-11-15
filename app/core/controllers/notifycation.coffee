"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.notifycation",
    url : "notifycation"
    views :
      "main@" :
        templateUrl : "/templates/notifycation/view.html"
        controller : "NotifycationCtrl"
route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval) ->
  console.log 'notifycation coffee '
  $scope.pagination =
    page:0
    limit: 20
  $scope.items = []

  $scope.modalNotify =
    id : 'id-modal-notifycation'
    title : 'CHI TIẾT'
    description:''
    item : {}
    show : ()->
      angular.element("##{@.id}").modal('show')
    close : ()->
      angular.element("##{@.id}").modal('hide')
    viewNow:(item)->
      $scope.modalNotify.close()
      $state.go 'base.room-detail', {id :  item.id}, {reload:true}

  $scope.openMessageDetail = (ite)->
    console.log 'openMessageDetail', ite
    $scope.modalNotify.show()
    $scope.modalNotify.item = ite
    $scope.modalNotify.title = ite.Message.title
    $scope.modalNotify.description = ite.Message.description

  ApiService.notificationList $scope.pagination,(err, result)->
    console.log 'notificationList in notifycation coffee;  result ',result
    $scope.items = result.items


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "NotifycationCtrl", ctrl
