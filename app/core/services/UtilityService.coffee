factory = ($rootScope, $timeout, $window, $http)->
  test : ()->

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

factory.$inject = ['$rootScope',
  '$timeout',
  '$window',
  '$http']

angular.module("app").factory "UtilityService", factory
