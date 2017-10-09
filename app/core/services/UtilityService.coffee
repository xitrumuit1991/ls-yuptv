factory = ($rootScope, $timeout, $window, $http, Notification)->
  test : ()->

  removeUserLogged : ()->
    delete window.localStorage.user
    delete window.localStorage.token
    $rootScope.user = null

  setUserProfile : (userResult)->
    return unless userResult
    window.localStorage.user = JSON.stringify(userResult)
    $rootScope.user = userResult

  setUserLogged : (userResult)->
    return unless userResult
    return unless userResult.token
    return unless userResult.user
    window.localStorage.token = userResult.token
    window.localStorage.user = JSON.stringify(userResult.user)
    $rootScope.user = userResult.user

  getUserLogger : ()->
    return  null unless window.localStorage.user
    return null unless window.localStorage.token
    try
      $rootScope.user = JSON.parse(window.localStorage.user)
      return $rootScope.user
    catch e
      console.log e
      return null

  setSettingNotify : (type = 'live-notification' , onOff = 'on')->
    window.localStorage[type] = onOff

  getSettingNotify : (type)->
    type = 'live-notification' unless type
    return 'off' unless window.localStorage[type]
    return window.localStorage[type]

  notifySuccess : (message)->
    Notification.success(message)
  notifyError : (message)->
    Notification.error(message)

factory.$inject = ['$rootScope',
  '$timeout',
  '$window',
  '$http',
'Notification'
]

angular.module("app").factory "UtilityService", factory
