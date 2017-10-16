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
  $scope.currentMoney = 0
  $scope.totalSendMoney = 0
  $scope.totalReceiveMoney = 0
  $scope.send =
    items : []
    page : 1
    limit: 20
    totalItems : 0
    onPageChange : ()->
      console.log '$scope.send.page',$scope.send.page
      $scope.getSendHistory()

  $scope.receive =
    items : []
    page : 1
    limit: 20
    totalItems : 0
    onPageChange : ()->
      console.log '$scope.receive.page',$scope.receive.page
      $scope.getReceiveHistory()


  $scope.changeTab = (tab)->
    $scope.activeView = tab

  $scope.getSendHistory = ()->
    return unless $rootScope.user
    param =
      userId:$rootScope.user.id
      limit : $scope.send.limit
      page : $scope.send.page
    ApiService.getHistorySendGift(param, (error, result)->
      return if error
      return if result and result.error
      $scope.send.items = result.items
      $scope.send.totalItems = result.attr.total_item
      $scope.totalSendMoney = result.totalCoins || 0

    )

  $scope.getReceiveHistory = ()->
    return unless $rootScope.user
    param =
      userId : $rootScope.user.id
      limit : $scope.receive.limit
      page : $scope.receive.page
    ApiService.getHistoryReceiveGift(param, (error, result)->
      return if error
      return if result and result.error
      $scope.receive.items = result.items
      $scope.receive.totalItems = result.attr.total_item
      $scope.totalReceiveMoney = result.totalCoins || 0
    )


  ApiService.getProfile({},(error, result)->
    return if error
    return if result and result.error
    $scope.currentMoney = result.money || 0

  )

  $scope.getSendHistory()
  $scope.getReceiveHistory()


  return
ctrl.$inject = [ '$rootScope', 'UtilityService', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval' , '$uibModal' ,'Upload'
]
angular
.module("app")
.config route
.controller "ProfileManagePropertyCtrl", ctrl
