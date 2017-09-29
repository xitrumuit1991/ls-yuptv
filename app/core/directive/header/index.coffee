


_directive = ($rootScope, $timeout, ApiService, $modal, $state) ->
  link = ($scope, $element, $attrs) ->
    $scope.menu = []
    $scope.classMenuMain = 'col-md-6'
    $scope.isLogged = false
    $scope.userProfile = null
    $scope.activeProfileMenu = false
    $scope.menuProfile = [
      {
        title : 'Trang Cá Nhân',
        href : 'base.profile',
        itemClass : 'col-md-2'
      },
      {
        title : 'Quản lý tài sản ',
        href : 'base.profile',
        itemClass : 'col-md-2'
      },
      {
        title : 'Nạp Xu',
        href : 'base.profile',
        itemClass : 'col-md-2'
      },
      {
        title : 'Quản Lý Tài Sản',
        href : 'base.profile',
        itemClass : 'col-md-2'
      },
      {
        title : 'Cài Đặt Thông Báo',
        href : 'base.profile.setting-notify',
        itemClass : 'col-md-2'
      },
    ]

    $rootScope.$watch('isHome', (data)->
      $scope.isHome = data
      if $scope.isHome is false
        $scope.classMenuMain = 'col-md-12'
      else
        $scope.classMenuMain = 'col-md-6'
    , true)

    $rootScope.$watch('menuMain', (data)->
      $scope.menu = data
    , true)

    $rootScope.$watch('user', (data)->
      if $rootScope.user
        $scope.isLogged = true
        $scope.userProfile = $rootScope.user
      else
        $scope.isLogged = false
        $scope.userProfile = null
    , true)

    $scope.openProfileMenuDropdown = (type = null)->
      if type != null
        $scope.activeProfileMenu = type
      else
        $scope.activeProfileMenu = !$scope.activeProfileMenu

    $scope.logout = ()->
      $rootScope.user = null
      delete window.localStorage.token
      delete window.localStorage.user
      $state.go 'base',{}, {reload:true}

    $scope.openLogin=()->
      $modal.open({
        templateUrl: '/templates/directive/header/login.html'
        backdrop: true
        windowClass: 'modal'
        controller: 'LoginHeaderCtrl'
      })
    return null

  directive =
    restrict : 'E'
    link : link
    templateUrl : '/templates/directive/header/view.html'
  return directive

_directive.$inject = ['$rootScope', '$timeout','ApiService' , '$modal', '$state']
angular
.module 'app'
.directive "header", _directive

