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

  $scope.step2ProviderSelected = null
  $scope.telcoCard =
    serial : ''
    code : ''

  $scope.step2BankSelected = null
  $scope.step2BankSelectedType = null

  $scope.checkPolicy =
    value : false

  $scope.stepView = 'step1'
  $scope.step1ChooseMethod = ''

  $scope.step2SelectedPackage = (item, $index)->
    $scope.step2PackageSelected = item


  $scope.step2SelectedProvider = (item, $index)->
    $scope.step2ProviderSelected = item

  $scope.step2SelectedBankType = (type )->
    $scope.step2BankSelectedType = type

  $scope.step2SelectedBank = (item, $index)->
    $scope.step2BankSelected = item

  $scope.submitTelcoCard = ()->

  $scope.submitBankNoiDia = ()->

  $scope.submitBankQuocTe = ()->


  $scope.goStep2 = (method)->
    $scope.stepView = 'step2'
    $scope.step1ChooseMethod = method

  $scope.backToStep1 = ()->
    $scope.stepView = 'step1'
    $scope.step2PackageSelected = null
    $scope.step2BankSelectedType = null
    $scope.step2BankSelected = null
    $scope.step1ChooseMethod = ''
    $scope.step2ProviderSelected = null
    $scope.telcoCard =
      serial : ''
      code : ''


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
