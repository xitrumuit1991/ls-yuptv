factory = ($rootScope, $timeout, $window, $http, Notification, ApiService)->
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
    if window.localStorage[type] is undefined  or typeof(window.localStorage[type]) == 'undefined'
      return null
    return window.localStorage[type]

  getMiliSecBeginDay : (type='now')->
    d = new Date()
    dd = new Date()
    if type == '+30day' then  d.setDate(dd.getDate()+30)
    if type == '+7day'  then  d.setDate(dd.getDate()+7)
    if type == '+3day'  then  d.setDate(dd.getDate()+3)
    if type == '+1day'  then  d.setDate(dd.getDate()+1)
    if type == 'now'    then d.setDate(dd.getDate())
    if type == '0day'    then d.setDate(dd.getDate())
    if type == '-1day'  then d.setDate(dd.getDate()-1)
    if type == '-3day'  then d.setDate(dd.getDate()-3)
    if type == '-7day'  then d.setDate(dd.getDate()-7)
    if type == '-30day'  then d.setDate(dd.getDate()-30)

    d.setTime( d.getTime() - d.getTimezoneOffset()*60*1000 )

    d.setHours(0)
    d.setMinutes(0)
    d.setSeconds(0)
    d.setMilliseconds(0)
    return Math.floor(d.getTime()/1000)

  notifySuccess : (message)->
    Notification.success(message)
  notifyError : (message)->
    Notification.error(message)

  reloadUserProfile : (cb=null)->
    ApiService.getProfile {}, (error, result)->
      return  if error
      return  if result and result.error
      window.localStorage.user = JSON.stringify(result) if result
      $rootScope.user = result if result
      return cb() if _.isFunction(cb)


factory.$inject = ['$rootScope',
  '$timeout',
  '$window',
  '$http',
'Notification','ApiService'
]

angular.module("app").factory "UtilityService", factory
