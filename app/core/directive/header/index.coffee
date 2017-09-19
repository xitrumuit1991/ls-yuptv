ctrlHandleLogin = ($scope, $modalInstance, ApiService, $state) ->
  $scope.login =
    username : ''
    password : ''
    storeInformation:false

  $scope.goRegister = ()->
    $modalInstance.dismiss 'cancel'
    $state.go 'base.register'

  $scope.submitLogin = ()->
    console.log 'submitLogin', $scope.login
    $modalInstance.dismiss 'cancel'
    return

  $scope.loginFacebook = ()->

  $scope.cancel = ()->
    console.log 'cancel'
    $modalInstance.dismiss 'cancel'
    return
  return
ctrlHandleLogin.$inject = ['$scope', '$modalInstance', 'ApiService', '$state']



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

