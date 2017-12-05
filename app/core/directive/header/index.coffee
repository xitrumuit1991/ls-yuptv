_directive = ($rootScope, $timeout, ApiService, $uibModal, $state,GlobalConfig, $location) ->
  link = ($scope, $element, $attrs) ->
    $scope.menu = []
    $scope.classMenuMain = 'col-md-6'
    $scope.isLogged = false
    $scope.userProfile = null
    $scope.activeProfileMenu = false
    $scope.menuProfile = GlobalConfig.menuMainProfile
    $scope.notifycationUnread =
      items : []

    $rootScope.searchKey =
      value : ''

    $scope.searchChange = ()->
      if $state.current.name == 'base.search'
        $state.transitionTo($state.current, {keyword : $rootScope.searchKey.value}, {
          reload: false, inherit: false, notify: false
        })
        return
      if $state.current.name != 'base.search'
        $state.go 'base.search', {keyword :$rootScope.searchKey.value }, {reload: true}
        return


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
      $uibModal.open({
        templateUrl: '/templates/directive/header/login.html'
        backdrop: true
        windowClass: 'modal'
        controller: 'LoginHeaderCtrl'
      })

    ApiService.notificationListUnread {page:0, limit: 1000},(err, result)->
      $scope.notifycationUnread = result

    $rootScope.$on 'reload-notify-unread',(event, data)->
      ApiService.notificationListUnread {page:0, limit: 1000},(err, result)->
        $scope.notifycationUnread = result


    return
  directive =
    restrict : 'E'
    link : link
    templateUrl : '/templates/directive/header/view.html'
  return directive

_directive.$inject = ['$rootScope', '$timeout','ApiService' , '$uibModal', '$state',
  'GlobalConfig', '$location'
]
angular
.module 'app'
.directive "header", _directive

