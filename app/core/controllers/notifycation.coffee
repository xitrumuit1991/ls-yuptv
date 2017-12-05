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
  $scope.loaded = false
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
      $timeout(()->
        $state.go 'base.room-detail', {id :  item.id}, {reload:true}
      ,500)

  $scope.openMessageDetail = (ite)->
    console.log 'openMessageDetail', ite
    $scope.modalNotify.show()
    $scope.modalNotify.item = ite
    $scope.modalNotify.title = ite.Message.title
    $scope.modalNotify.description = ite.Message.description
    ApiService.setNotificationRead {id : ite.id},(err, result)->
      index = _.findIndex($scope.items,{id: ite.id})
      if index != -1
        $scope.items[index].status = 1
      $rootScope.$emit 'reload-notify-unread',{}

  ApiService.notificationList $scope.pagination,(err, result)->
    console.log 'notificationList in notifycation coffee;  result ',result
    $scope.items = result.items
    $scope.loaded = true


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "NotifycationCtrl", ctrl
