appRun = (
  $rootScope,
  $state,
  $stateParams,
  $timeout,
  $location,
  ApiService,
  GlobalConfig)->
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
  menuMainProfile = [
    {
      title : 'Trang Cá Nhân',
      href : 'base.profile.user-info',
      itemClass : 'col-md-2'
    },
    {
      title : 'Quản lý tài sản ',
      href : 'base.profile.manage-asset',
      itemClass : 'col-md-2'
    },
    {
      title : 'Nạp Xu',
      href : 'base.profile.charge-ucoin',
      itemClass : 'col-md-2'
    },
    {
      title : 'Quản lý phòng',
      href : 'base.profile.manage-room',
      itemClass : 'col-md-2'
    },
    {
      title : 'Cài Đặt Thông Báo',
      href : 'base.profile.setting-notify',
      itemClass : 'col-md-2'
    },
  ]

  if window.localStorage.user
    try
      $rootScope.user = JSON.parse(window.localStorage.user)
      console.info '$rootScope.user =',$rootScope.user
    catch e
      $rootScope.user = null
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
      $rootScope.menuMain = menuMainProfile
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
  'GlobalConfig'
]

angular.module("app").run(appRun)

