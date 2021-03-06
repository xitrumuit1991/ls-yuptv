"use strict"
route = ($stateProvider, GlobalConfig)->
  $stateProvider
  .state "base.register",
    url : "register"
    views :
      "main@" :
        templateUrl : "/templates/register/view.html"
        controller : "registerCtrl"
route.$inject = ['$stateProvider', 'GlobalConfig']
ctrl = ($rootScope,
  $scope, $timeout, $location,
  $window, $state, $stateParams,  ApiService, $http,
  GlobalConfig, $interval, Notification) ->
  console.log 'register coffee '
  rexPhone = /^0[1-9]{1}[0-9]{8,12}$/;
  rexEmail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  basicOb =
    username : ''
    phone: ''
    password: ''
    repassword : ''
    checkPolicy : false
    error : ''
  $scope.register = _.clone basicOb

  validateRegister = ()->
    if $scope.register.username.length < 6
      $scope.register.error = 'Tên người dùng ít nhất 6 kí tự '
      return false
    if rexPhone.test($scope.register.phone) is false
      $scope.register.error = 'Số điện thoại không đúng định dạng '
      return false
    if $scope.register.password.length < 6
      $scope.register.error = 'Mật khẩu ít nhất 6 kí tự '
      return false
    if $scope.register.password != $scope.register.repassword
      $scope.register.error = 'Mật khẩu nhập lại không đúng'
      return false
    if $scope.register.checkPolicy == false
      $scope.register.error = 'Vui lòng đồng ý với các điều khoản sử dụng'
      return false
    return true

  $scope.submitRegisterAccountKit = ()->
    if !$scope.register.username or !$scope.register.phone or !$scope.register.password or !$scope.register.repassword
      $scope.register.error = 'Vui lòng nhập đầy đủ thông tin'
      return
    return if validateRegister() == false
    paramAccountKit =
      countryCode: '+84',
      phoneNumber: $scope.register.phone
    AccountKit.login 'PHONE', paramAccountKit,(response)->
      console.log 'AccountKit.login response',response
      if response and response.status isnt "PARTIALLY_AUTHENTICATED" #if response and response.status in ['NOT_AUTHENTICATED','BAD_PARAMS']
        return Notification.error('Không thể gửi OTP code.')
      if response and response.status is "PARTIALLY_AUTHENTICATED"
        params =
          password : $scope.register.password
          name : $scope.register.username
          phone : $scope.register.phone
        params.code = response.code if response.code
        params.access_token = response.access_token if response.access_token and !params.code
        ApiService.registerAccountByAccountKit params, (error, result)->
          if result and result.error
            return Notification.error(result.message)
          console.log 'registerAccountByAccountKit result=',result
          Notification.success('Đăng kí tài khoản thành công. Bạn có thể đăng nhập ngay bây giờ!')
          $scope.register = _.clone basicOb
          $timeout(()->
            $rootScope.$emit 'login-from-reset-password', {}
            $state.go 'base'
          ,1000)



  $scope.submitRegister = ()->
    if !$scope.register.username or !$scope.register.phone or !$scope.register.password or !$scope.register.repassword
      $scope.register.error = 'Vui lòng nhập đầy đủ thông tin'
      return
    return if validateRegister() == false
    params =
      phone : $scope.register.phone
      password : $scope.register.password
      name : $scope.register.username
    console.log 'registerAccount=',params
    ApiService.registerAccount params, (error, result)->
      $scope.register.error=''
      if error
        console.error error
        Notification.error(error)
        return
      if result and result.error
        return Notification.error(result.message)
      console.log result
      paramsActive =
        phone: $scope.register.phone,
        code : if result.code then result.code.toString() else ''
      ApiService.registerAccountActive paramsActive,(err, res)->
        console.log 'res active code=',res
        if err
          return Notification.error(JSON.stringify(err))
        if res and res.error
          return Notification.error(res.message)
        if res and res.verify == true
          Notification.success('Đăng kí tài khoản thành công')
          $scope.register =
            username : ''
            phone: ''
            password: ''
            repassword : ''
            checkPolicy : false
            error : ''
          $state.go 'base',{reload:true}
      return

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'Notification'
]
angular
.module("app")
.config route
.controller "registerCtrl", ctrl
