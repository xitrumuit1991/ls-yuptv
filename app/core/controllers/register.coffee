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
  $scope.register =
    username : ''
    phone: ''
    password: ''
    repassword : ''
    checkPolicy : false
    error : ''

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

  $scope.submitRegister = ()->
    if !$scope.register.username or !$scope.register.phone or !$scope.register.password or !$scope.register.repassword
      $scope.register.error = 'Vui lòng nhập đầy đủ thông tin'
      return
    if validateRegister() == false
      return
    params =
      phone : $scope.register.phone
      password : $scope.register.password
      name : $scope.register.username
    console.log 'registerAccount=',params
    ApiService.registerAccount(params, (error, result)->
      $scope.register.error=''
      if error
        console.error error
        Notification.error(error)
        return
      if result and result.error
        return Notification.error(result.message)
      console.log result
      Notification.success('Đăng kí tài khoản thành công')
      return
    )

ctrl.$inject = [
  '$rootScope', '$scope', '$timeout', '$location',
  '$window', '$state', '$stateParams',  'ApiService', '$http',
  'GlobalConfig', '$interval', 'Notification'
]
angular
.module("app")
.config route
.controller "registerCtrl", ctrl
