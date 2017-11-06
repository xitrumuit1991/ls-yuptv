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
  $rootScope.user = null
  if window.localStorage.user and window.localStorage.token
    try
      $rootScope.user = JSON.parse(window.localStorage.user)
    catch e
#    console.info 'app run validate user token'
    ApiService.getProfile {}, (error, result)->
      return UtilityService.removeUserLogged() if error
      return UtilityService.removeUserLogged() if result and result.error
      if result
        try
          $rootScope.user = JSON.parse(window.localStorage.user)
        catch e
          $rootScope.user = null
  console.info '$rootScope.user',$rootScope.user
#  console.info 'window.localStorage.token',window.localStorage.token

  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams
  $rootScope.$on '$viewContentLoaded', ()->
  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams)->
#    console.log 'fromState',fromState
#    console.log 'toState',toState
    if toState and toState.name.indexOf('base.profile') != -1
      $rootScope.isHome = false
      $rootScope.menuMain = GlobalConfig.menuMainProfile
    else
      $rootScope.isHome = true
      $rootScope.menuMain = GlobalConfig.menuMainHome


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

