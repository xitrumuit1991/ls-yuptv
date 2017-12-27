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
    total_item:0
    pageOnChange:()->
      $scope.getListNotify()

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
      ,1)

  $scope.openMessageDetail = (ite)->
    console.log 'openMessageDetail', ite
    ApiService.getRoomDetail {roomId : ite.Message.Room.id},(err, room)->
      console.log 'getRoomDetail', room
      ite.Room = room
      $scope.modalNotify.show()
      $scope.modalNotify.item = ite
      $scope.modalNotify.title = ite.Message.title
      $scope.modalNotify.description = ite.Message.description
      console.log 'openMessageDetail', ite
      #update read
      ApiService.setNotificationRead {id : ite.id},(err, result)->
        index = _.findIndex($scope.items,{id: ite.id})
        $scope.items[index].status = 1 if index != -1
        $rootScope.$emit 'reload-notify-unread',{}

  $scope.getListNotify = ()->
    param =
      page : $scope.pagination.page
      limit : $scope.pagination.limit
    ApiService.notificationList param,(err, result)->
      return if err or !result
      console.log 'notificationList in notifycation coffee;  result ',result
      $scope.items = result.items
      $scope.loaded = true
      $scope.pagination.total_item = result.attr.total_item


  $scope.getListNotify()


ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval'
]
angular
.module("app")
.config route
.controller "NotifycationCtrl", ctrl
