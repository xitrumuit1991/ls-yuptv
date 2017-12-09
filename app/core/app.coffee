config =
  platform : 'web'
  version : '1.0.0'
  uuid : (new Fingerprint({canvas : true, screen_resolution : false})).get()
  modelName : navigator.userAgent
#  fBappId : '1933860780272829' #dev
  fBappId : '144785392941236' #production
  API_URL : "http://api.yuptv.vn/api/v1/"
  env : 'production'
  accKitAppId : '1933860780272829'
  accKitVersion : 'v1.1'
  accKitToken: 'ed921b9e2248d0cb68329322c08e97b3'

config.menuMainHome = [
  {
    title : 'Kênh On Air',
    icon : 'fa-video-camera'
    href : 'base.on-air'
    itemClass : 'col-md-4'
  },
  {
    title : 'Lịch Diễn',
    icon : 'fa-calendar-o'
    href : 'base.schedule'
    itemClass : 'col-md-4'
  },
  {
    title : 'Tin Tức',
    icon : 'fa-file'
    href : 'http://tintuc.livestar.vn'
    isLink : true
    itemClass : 'col-md-4'
  },
]

config.menuMainProfile = [
  {
    title : 'Trang Cá Nhân',
    href : 'base.profile',
    itemClass : 'col-md-2'
  },
  {
    title : 'Quản lý tài sản ',
    href : 'base.profile.manage-property',
    itemClass : 'col-md-2'
  },
  {
    title : 'Nạp Ucoin',
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

switch window.ENV
  when 'production'
    config = _.extend config,
      fBappId : '144785392941236'
      API_URL : "http://api.yuptv.vn/api/v1/"
      LIVE_DOMAIN : 'http://livestream.yuptv.vn/'
      SOCKET_DOMAIN : 'https://socket.yuptv.vn/'
      env : 'production'
  when 'prod'
    config = _.extend config,
      fBappId : '144785392941236'
      API_URL : "http://api.yuptv.vn/api/v1/"
      LIVE_DOMAIN : 'http://livestream.yuptv.vn/'
      SOCKET_DOMAIN : 'https://socket.yuptv.vn/'
      env : 'production'

  when 'development'
    config = _.extend config,
      fBappId : '1933860780272829'
      API_URL : "http://dev.livestar.vn:1010/api/v1/"
      LIVE_DOMAIN : 'http://livestream.yuptv.vn/'
      SOCKET_DOMAIN : 'http://dev.livestar.vn:8050'
      env : 'development'

  when 'dev'
    config = _.extend config,
      fBappId : '1933860780272829'
      API_URL : "http://dev.livestar.vn:1010/api/v1/"
      LIVE_DOMAIN : 'http://livestream.yuptv.vn/'
      SOCKET_DOMAIN : 'http://dev.livestar.vn:8050'
      env : 'development'

initInjector = angular.injector(["ng"])
$http = initInjector.get("$http");

angular
.module("app", [
  "ngResource",
  "ngMessageFormat",
#  'ngAnimate',
  "ui.router",
  "facebook",
  "ngSanitize",
  "angularFileUpload",
  "fancyboxplus",
  "ui.bootstrap",
  "ui.carousel",
  "ui-notification",
  "ngProgress",
  "angular-loading-bar",
  'ngFileUpload',
  '720kb.datepicker',
  '720kb.socialshare',
  'ui.bootstrap.datetimepicker',
  'slick'
#  'vjs-video'
])
.constant "AppName", "YUP"
.constant "GlobalConfig", config

appConfig = ($locationProvider,
  $stateProvider,
  $urlRouterProvider,
  FacebookProvider,
  GlobalConfig,
  $httpProvider,
  NotificationProvider, cfpLoadingBarProvider) ->

  $httpProvider.interceptors.push "AuthInterceptor"
  $locationProvider.html5Mode(true).hashPrefix "!"
  $urlRouterProvider.otherwise "/"
  FacebookProvider.init config.fBappId
  NotificationProvider.setOptions({
    delay : 5000,
    startTop : 20,
    startRight : 20,
    verticalSpacing : 20,
    horizontalSpacing : 20,
    positionX : 'right',
    positionY : 'top'
  })
  cfpLoadingBarProvider.includeSpinner = true
  cfpLoadingBarProvider.includeBar = true

appConfig.$inject = [
  '$locationProvider',
  '$stateProvider',
  '$urlRouterProvider',
  'FacebookProvider',
  'GlobalConfig',
  '$httpProvider',
  'NotificationProvider', 'cfpLoadingBarProvider'
]

angular
.module("app")
.config appConfig

angular.element(document).ready ()->
  angular.bootstrap document, ['app'], strictDi : true