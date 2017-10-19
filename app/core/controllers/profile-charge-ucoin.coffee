#quan ly tai san
"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.profile.charge-ucoin",
    url : "/charge-ucoin"
    templateUrl : "/templates/profile/charge-ucoin.html"
    controller : "ProfileChargeUcoinCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']

ctrl = ($rootScope, UtilityService, $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, $uibModal, Upload)->
  $scope.listPackage = []
  $scope.step2PackageSelected = null
  $scope.checkPolicy =
    value : false

  $scope.stepView = 'step1'
  $scope.step1ChooseMethod = ''

  $scope.step2SelectedPackage = (item, $index)->
    $scope.step2PackageSelected = item

  $scope.goStep2 = (method)->
    $scope.stepView = 'step2'
    $scope.step1ChooseMethod = method

#    console.log 'checkPolicy',$scope.checkPolicy.value
#    console.log '$scope.packageSelected',$scope.packageSelected
#    return if $scope.checkPolicy.value == false
#    return unless $scope.packageSelected.id
#    $scope.stepView = 'step2'


  $scope.getListPackage = ()->
    ApiService.getListPackage {},(error, result)->
      return if error
      return if result and result.error
      $scope.listPackage = result

  $scope.getListPackage()



  return
ctrl.$inject = [ '$rootScope', 'UtilityService', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval' , '$uibModal' ,'Upload'
]
angular
.module("app")
.config route
.controller "ProfileChargeUcoinCtrl", ctrl
