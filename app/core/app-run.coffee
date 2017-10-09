appRun = (
  $rootScope,
  $state,
  $stateParams,
  $timeout,
  $location,
  ApiService,
  GlobalConfig, UtilityService)->
  console.info 'GlobalConfig=',GlobalConfig
  $rootScope.isHome = true
  menuMainHome = [
    {
      title : 'Kênh On Air',
      icon : 'fa-video-camera'
      href : 'base.on-air'
      itemClass : 'col-md-4'
    },
    {
      title : 'Lịch Phát Sóng',
      icon : 'fa-calendar-o'
      href : 'base.schedule-page'
      itemClass : 'col-md-4'
    },
    {
      title : 'Tin Tức',
      icon : 'fa-file'
      href : 'base.news'
      itemClass : 'col-md-4'
    },
  ]

  if window.localStorage.user and window.localStorage.token
    console.info 'app run validate user token'
    ApiService.getProfile({}, (error, result)->
      return UtilityService.removeUserLogged() if error
      if result and result.error
        return UtilityService.removeUserLogged()
      if result
        try
          $rootScope.user = JSON.parse(window.localStorage.user)
          console.info '$rootScope.user =',$rootScope.user
        catch e
          $rootScope.user = null
    )
  else
    $rootScope.user = null

  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams
  $rootScope.$on '$viewContentLoaded', ()->
  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams)->
    console.log 'fromState',fromState
    console.log 'toState',toState
    if toState and toState.name.indexOf('base.profile') != -1
      $rootScope.isHome = false
      $rootScope.menuMain = GlobalConfig.menuMainProfile
    else
      $rootScope.isHome = true
      $rootScope.menuMain = menuMainHome


appRun.$inject = [
  '$rootScope',
  '$state',
  '$stateParams',
  '$timeout',
  '$location',
  'ApiService',
  'GlobalConfig', 'UtilityService'
]

angular.module("app").run(appRun)

