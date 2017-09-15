appRun = (
  $rootScope,
  $state,
  $stateParams,
  $timeout,
  $location,
  ApiService,
  GlobalConfig)->
  console.info 'GlobalConfig=',GlobalConfig
  $rootScope.user = null
  if window.localStorage.user
    try
      $rootScope.user = JSON.parse(window.localStorage.user)
    catch e
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams
  $rootScope.$on '$viewContentLoaded', ()->
  $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams)->

appRun.$inject = [
  '$rootScope',
  '$state',
  '$stateParams',
  '$timeout',
  '$location',
  'ApiService',
  'GlobalConfig'
]

angular.module("app").run(appRun)

