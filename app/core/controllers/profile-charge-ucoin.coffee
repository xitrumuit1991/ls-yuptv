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


  $scope.listPackage = []
  $scope.step2PackageSelected = null

  $scope.step2ProviderSelected = null
  $scope.telcoCard =
    serial : ''
    code : ''

  $scope.redeemCode =
    code : ''
    submitRedeemCode :()->
      param =
        code:$scope.redeemCode.code
        key_redeem:'key_redeem' #only mobile web
        skipCaptcha : true
      ApiService.redeemCode param,(err, result)->
        return UtilityService.notifyError(err.message) if err
        return UtilityService.notifyError(result.message) if result and result.error
        UtilityService.notifySuccess(result.message) if result
        UtilityService.reloadUserProfile() if result


  $scope.step2BankSelected = null
  $scope.step2BankSelectedType = null

  $scope.checkPolicy =
    value : false

  $scope.stepView = 'step1'
  $scope.step1ChooseMethod = ''

  $scope.step2SelectedPackageBank = (item, $index)->
    $scope.step2PackageSelected = item # package
    $scope.step2BankSelectedType = "the-noi-dia"

  $scope.step2SelectedBankType = (type )->
    $scope.step2BankSelectedType = type #noi dia, quoc te

  $scope.step2SelectedBank = (item, $index)->
    $scope.step2BankSelected = item # ngan hang nao




  $scope.step2SelectedPackage = (item, $index)->
    $scope.step2PackageSelected = item # package

  $scope.step2SelectedProvider = (item, $index)->
    console.log 'step2SelectedProvider',item
    $scope.step2ProviderSelected = item




  $scope.submitTelcoCard = ()->
    console.log '$scope.step2PackageSelected',$scope.step2PackageSelected
    console.log '$scope.step2ProviderSelected',$scope.step2ProviderSelected
    return if $scope.step1ChooseMethod != 'card'
    return UtilityService.notifyError('Vui lòng điền thông tin thẻ') if !$scope.telcoCard.serial or !$scope.telcoCard.code
    params =
      card_pin	: $scope.telcoCard.code
      card_serial : $scope.telcoCard.serial
      card_serviceProvider	: $scope.step2ProviderSelected.name
      sourceId :  $scope.step2ProviderSelected.id
      packageId : if $scope.step2PackageSelected then $scope.step2PackageSelected.id else ''
      skipCaptcha : true
      key_payment : 'key_payment'
    console.log 'options submitTelcoCard', params
    ApiService.chargeByTelcoCard params,(error , result)->
      if error
        msg = if result and result.message then result.message else 'Hệ thống đang bận, vui lòng thử lại sau'
        UtilityService.notifyError(msg)
        return
      if result and result.error
        msg = result.message or 'Hệ thống đang bận, vui lòng thử lại sau'
        UtilityService.notifyError(msg)
        return
      if result
        UtilityService.notifySuccess(result.message)



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
