"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.search",
    url : "search?keyword"
    views :
      "main@" :
        templateUrl : "/templates/search/view.html"
        controller : "SearchCtrl"
route.$inject = ['$stateProvider', 'GlobalConfig']


ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, UtilityService) ->
  $scope.keySearch = ''

  console.log 'SearchCtrl coffee $stateParams.keyword=', $stateParams.keyword
  $scope.pagination =
    page:0
    limit: 20
    total_item:0
    total_page:0
    pageOnChange:()->
      $scope.loadDataSearch($rootScope.searchKey.value)

  $scope.items = []

  $scope.loadDataSearch = (keyword)->
    param =
      page : $scope.pagination.page
      limit : $scope.pagination.limit
      keyword:keyword
    ApiService.searchRoomByKeyword param,(err, result)->
#      console.log 'SearchCtrl in SearchCtrl coffee;  result ',result
      return if err
      return if result and result.error
      $scope.items = result.rooms

  $rootScope.$watch 'searchKey',(data)->
    console.log 'searchKey change',data
    $scope.keySearch = data.value
    $scope.loadDataSearch(data.value) if data
  ,true

  $scope.loadDataSearch($stateParams.keyword) if $stateParams.keyword
  if !$rootScope.searchKey or !$rootScope.searchKey.value
    $rootScope.searchKey =
      value : $stateParams.keyword

  $scope.followIdolSearchPage = (room, index)->
    return unless room
    ApiService.followIdol({roomId:room.id},(error, result)->
      return if error
      return UtilityService.notifyError(result.message) if result and result.error
      UtilityService.notifySuccess(result.message)
      $scope.items[index].isFollow = true
    )




ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval','UtilityService'
]
angular
.module("app")
.config route
.controller "SearchCtrl", ctrl
