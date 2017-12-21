appRun = (
  $rootScope,
  $state,
  $stateParams,
  $timeout,
  $location,
  ApiService,
  GlobalConfig,
  UtilityService)->
  console.warn 'GlobalConfig=',GlobalConfig
  $rootScope.isHome = true
  if window.localStorage.user and window.localStorage.token
    ApiService.getProfile {}, (error, result)->
      return UtilityService.removeUserLogged() if error
      return UtilityService.removeUserLogged() if result and result.error
      if result
        try
          window.localStorage.user = JSON.stringify(result)
          $rootScope.user = result
          console.warn '$rootScope.user',$rootScope.user
          console.warn 'window.localStorage.token',window.localStorage.token
        catch e
          $rootScope.user = null
  else
    $rootScope.user = null

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

  ApiService.getListBanner {},(error, result)->
    return if error
    $rootScope.homeslides = result if result

  $(document).ready ()->
    $timeout(()->
      paramInitAccKit =
        appId: GlobalConfig.accKitAppId
        state: GlobalConfig.accKitToken
        version: GlobalConfig.accKitVersion
      AccountKit.init(paramInitAccKit)
#      console.warn('AccountKit',AccountKit)
    ,2000)

    $(window).scroll ()->
      if $(this).scrollTop() > 100
        $('#scrollToTop').fadeIn()
      else
        $('#scrollToTop').fadeOut()
    $('#scrollToTop').click ()->
      $('html, body').animate { scrollTop: 0 }, 500
      false

appRun.$inject = [
  '$rootScope',
  '$state',
  '$stateParams',
  '$timeout',
  '$location',
  'ApiService',
  'GlobalConfig',
  'UtilityService'
]

angular.module("app").run(appRun)

