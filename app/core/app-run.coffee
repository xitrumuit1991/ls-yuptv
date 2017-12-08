appRun = (
  $rootScope,
  $state,
  $stateParams,
  $timeout,
  $location,
  ApiService,
  GlobalConfig,
  UtilityService)->

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
  console.warn '$rootScope.user',$rootScope.user
  console.warn 'window.localStorage.token',window.localStorage.token

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
    $(window).scroll ()->
      if $(this).scrollTop() > 100
        $('#scrollToTop').fadeIn()
      else
        $('#scrollToTop').fadeOut()
      return
    $('#scrollToTop').click ()->
      $('html, body').animate { scrollTop: 0 }, 500
      false

    paramInitAccKit =
      appId:'1933860780272829'
      state:'ed921b9e2248d0cb68329322c08e97b3'
      version:'v2.10'
    AccountKit.init( paramInitAccKit )


    return

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

