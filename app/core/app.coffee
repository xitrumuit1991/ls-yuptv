config =
  platform : 'web'
  version : '1.0.0'
  uuid : (new Fingerprint({canvas : true, screen_resolution : false})).get()
  modelName : navigator.userAgent
  fBappId : '1933860780272829'
  API_URL : "http://dev.livestar.vn:1010/api/v1/"
  env : 'production'

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

switch ENV
  when 'production'
    config = _.extend config,
      fBappId : '1933860780272829'
      API_URL : "http://api.yuptv.vn/"
      LIVE_DOMAIN : 'http://livestream.yuptv.vn/'
      SOCKET_DOMAIN : 'http://socket.yuptv.vn/'
      env : 'production'
#      1. API: http://api.yuptv.vn/
#      2. Livestream: http://livestream.yuptv.vn/
#      3. Socket: http://socket.yuptv.vn/
#      4. Web: http://www.yuptv.vn/
#      5. Admintool: http://admin.yuptv.vn/

  when 'development'
    config = _.extend config,
      fBappId : '1933860780272829'
      API_URL : "http://dev.livestar.vn:1010/api/v1/"
      LIVE_DOMAIN : 'http://livestream.yuptv.vn/'
      SOCKET_DOMAIN : 'http://socket.yuptv.vn/'
      env : 'development'

  when 'dev'
    config = _.extend config,
      fBappId : '1933860780272829'
      API_URL : "http://dev.livestar.vn:1010/api/v1/"
      LIVE_DOMAIN : 'http://livestream.yuptv.vn/'
      SOCKET_DOMAIN : 'http://socket.yuptv.vn/'
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
  'ui.bootstrap.datetimepicker'
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