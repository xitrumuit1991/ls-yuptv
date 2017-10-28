#quan ly tai san
"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.profile.charge-ucoin",
    url : "/charge-ucoin?transId&responseCode&mac"
    templateUrl : "/templates/profile/charge-ucoin.html"
    controller : "ProfileChargeUcoinCtrl"

route.$inject = ['$stateProvider', 'GlobalConfig']

ctrl = ($rootScope, UtilityService, $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, $uibModal, Upload)->

  console.log '$location.search().transId', $location.search().transId
  console.log '$location.search().responseCode', $location.search().responseCode
  console.log '$location.search().mac', $location.search().mac
  if $location.search().transId and $location.search().responseCode and  $location.search().mac
    paramConfirmBankLocal =
      transId:$location.search().transId
      responseCode:$location.search().responseCode
      mac:$location.search().mac
    ApiService.confirmChargeBankLocal(paramConfirmBankLocal,(error, result)->
      return UtilityService.notifyError(result.message) if error
      return UtilityService.notifyError(result.message) if result and result.error
      UtilityService.notifySuccess(result.message) if result
    )

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
    $scope.step2PackageSelected = item # package


  $scope.step2SelectedProvider = (item, $index)->
    $scope.step2ProviderSelected = item

  $scope.step2SelectedBankType = (type )->
    $scope.step2BankSelectedType = type #noi dia, quoc te

  $scope.step2SelectedBank = (item, $index)->
    $scope.step2BankSelected = item # ngan hang nao

  $scope.submitTelcoCard = ()->
    console.log 'thanh toan telco'
    console.log '$scope.step2PackageSelected',$scope.step2PackageSelected
    console.log '$scope.step2ProviderSelected',$scope.step2ProviderSelected
    return if $scope.step1ChooseMethod != 'card'
    return UtilityService.notifyError('Vui lòng điền thông tin thẻ') unless $scope.telcoCard.serial
    return UtilityService.notifyError('Vui lòng điền thông tin thẻ') unless $scope.telcoCard.code
    params =
      card_pin	: $scope.telcoCard.code
      card_serial : $scope.telcoCard.serial
      card_serviceProvider	: $scope.step2ProviderSelected.name
      sourceId :  $scope.step2ProviderSelected.id
      packageId : $scope.step2PackageSelected.id
      skipCaptcha : true
      key_payment : 'key_payment'
    console.log 'options submitTelcoCard', params
    ApiService.chargeByTelcoCard(params,(error , result)->
      return UtilityService.notifyError(result.message) if error
      return UtilityService.notifyError(result.message) if result and result.error
      UtilityService.notifySuccess(result.message) if result
    )



  $scope.submitBankNoiDia = ()->
    console.log 'submitBankNoiDia'
    console.log '$scope.step2PackageSelected',$scope.step2PackageSelected
    console.log '$scope.step2BankSelectedType', $scope.step2BankSelectedType
    console.log '$scope.step2BankSelected', $scope.step2BankSelected
    return if $scope.step1ChooseMethod != 'internetbanking'
    params =
      fullname	: ''
      bankId : $scope.step2BankSelected.code
      sourceId : $scope.step2BankSelected.id
      packageId: $scope.step2PackageSelected.id
      key_megabank : 'key_megabank'
      callbackUrl : '/profile/charge-ucoin'
      skipCaptcha : true
    console.log 'options submitBankNoiDia', params
    ApiService.chargeBankLocal(params,(error , result)->
      return UtilityService.notifyError(result.message) if error and result
      return UtilityService.notifyError(result.message) if result and result.error
      console.log 'chargeBankLocal result=',result
      return window.location.href = result.url if result and result.url
      UtilityService.notifySuccess(result.message) if result
    )


  $scope.submitBankQuocTe = ()->
    return UtilityService.notifyError('Oop! Phương thức thanh toán chưa được hỗ trợ ')


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
