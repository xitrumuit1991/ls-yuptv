ctrlHandleLogin = ($scope, $modalInstance, ApiService, $state, Facebook,UtilityService) ->
  $scope.login =
    phone : ''
    password : ''
    storeInformation:false
    error:''

  $scope.goRegister = ()->
    $modalInstance.dismiss 'cancel'
    $state.go 'base.register'

  $scope.submitLogin = ()->
    console.log 'submitLogin', $scope.login
    if !$scope.login.phone or !$scope.login.password
      return $scope.login.error = 'Vui lòng điền thông tin'
    rexPhone = /^0[1-9]{1}[0-9]{8,12}$/;
    if rexPhone.test($scope.login.phone) is false
      return  $scope.login.error = 'Số điện thoại không đúng định dạng'
    if $scope.login.password.length < 6
      return  $scope.login.error = 'Mật khẩu ít nhất 6 kí tự'
    params= {phone: $scope.login.phone , password : $scope.login.password}
    ApiService.loginPhone(params,(error, result)->
      console.log error
      console.log result
      if error
        $scope.login.error = error
        return
      if result and result.error
        $scope.login.error = result.message
        return
      $scope.login.error = ''
      UtilityService.setUserLogged(result)
      $state.go 'base', {reload: true}
      $modalInstance.dismiss 'cancel'
      return
    )
    return

  $scope.loginFacebook = ()->
    doneGetTokenFacebook = (response) ->
      console.warn('respone cua fb', response)
      if response.status isnt "connected"
        $scope.login.error = 'Không thể lấy token từ facebook'
        return
      ApiService.loginFacebook({access_token: response.access_token }, (error, result)->
        console.log result
        if error
          console.log error
          return
        if result and result.error
          $scope.login.error = result.message
          return
        $scope.login.error = ''
        UtilityService.setUserLogged(result)
        $state.go 'base', {reload: true}
        $modalInstance.dismiss 'cancel'
        return
      )
    Facebook.login doneGetTokenFacebook, {scope : 'email,public_profile'}

  $scope.cancel = ()->
    console.log 'cancel'
    $modalInstance.dismiss 'cancel'
    return
  return
ctrlHandleLogin.$inject = ['$scope', '$modalInstance', 'ApiService', '$state', 'Facebook',
'UtilityService'
]



_directive = ($timeout, ApiService, $modal) ->
  link = ($scope, $element, $attrs) ->
    $scope.openLogin=()->
      $modal.open({
        templateUrl: '/templates/directive/header/login.html'
        backdrop: true
        windowClass: 'modal'
        controller: ctrlHandleLogin
      })
    return null

  directive =
    restrict : 'E'
    link : link
    templateUrl : '/templates/directive/header/view.html'
  return directive

_directive.$inject = ['$timeout','ApiService' , '$modal']
angular
.module 'app'
.directive "header", _directive

