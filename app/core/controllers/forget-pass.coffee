"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
    .state "base.forget-pass",
    url : "quen-mat-khau"
    views :
      "main@" :
        templateUrl : "/templates/forget-pass/view.html"
        controller : "ForgetPassCtrl"
route.$inject = ['$stateProvider', 'GlobalConfig']
ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, UtilityService, Notification) ->

  $scope.item =
    phone : ''
    password : ''
    repassword : ''

  $scope.submit = ()->
    return Notification.error('Vui lòng nhập vào số điện thoại ') if !$scope.item.phone
    return Notification.error('Vui lòng nhập vào mật khẩu ') if !$scope.item.password or !$scope.item.repassword
    return Notification.error('Mật khẩu ít nhất 6 kí tự') if $scope.item.password.length < 6
    return Notification.error('Mật khẩu nhập lại không đúng') if $scope.item.password != $scope.item.repassword
    rexPhone = /^0[1-9]{1}[0-9]{8,12}$/;
    if rexPhone.test($scope.item.phone) is false
      Notification.error 'Số điện thoại không đúng định dạng '
      return
    paramAccKit =
      countryCode: '+84',
      phoneNumber: $scope.item.phone
    AccountKit.login('PHONE', paramAccKit,(response)->
      console.log 'AccountKit.login response',response
      if response and response.status isnt "PARTIALLY_AUTHENTICATED" #if response and response.status in ['NOT_AUTHENTICATED','BAD_PARAMS']
        return Notification.error('Không thể gửi OTP code.')
      if response and response.status is "PARTIALLY_AUTHENTICATED"
        paramReset =
          password : $scope.item.password
          code : response.code
          flush_token : true
        ApiService.resetPasswordByAccountKit(paramReset, (err, result)->
          if result and result.error
            return Notification.error(result.message)
          console.log 'resetPasswordByAccountKit result=',result
          Notification.success('Thay đổi mật khẩu mới thành công. Bạn có thể đăng nhập ngay bây giờ!')
          $timeout(()->
            $rootScope.$emit 'login-from-reset-password', {}
          ,1000)
        )
    );

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval','UtilityService','Notification'
]
angular
  .module("app")
  .config route
  .controller "ForgetPassCtrl", ctrl
