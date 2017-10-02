config =
  platform : 'web'
  version : '1.0.0'
  uuid : (new Fingerprint({canvas : true, screen_resolution : false})).get()
  modelName : navigator.userAgent
  fBappId : '1933860780272829'
  API_URL : "http://dev.livestar.vn:1010/api/v1/"
  env : 'production'
  menuMainProfile : [
    {
      title : 'Trang Cá Nhân',
      href : 'base.profile',
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

switch ENV
  when 'production'
    config = _.extend config,
      fBappId : '1933860780272829'
      API_URL : "http://dev.livestar.vn:1010/api/v1/"
      env : 'production'

  when 'development'
    config = _.extend config,
      fBappId : '1933860780272829'
      API_URL : "http://dev.livestar.vn:1010/api/v1/"
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
  "angular-loading-bar"
])
.constant "AppName", "YUP"
.constant "GlobalConfig", config


appConfig = (
  $locationProvider,
  $stateProvider,
  $urlRouterProvider,
  FacebookProvider,
  GlobalConfig,
  $httpProvider,
  NotificationProvider,cfpLoadingBarProvider) ->

  $httpProvider.interceptors.push "AuthInterceptor"
  $locationProvider.html5Mode(true).hashPrefix "!"
  $urlRouterProvider.otherwise "/"
  FacebookProvider.init config.fBappId
  NotificationProvider.setOptions({
    delay: 5000,
    startTop: 20,
    startRight: 20,
    verticalSpacing: 20,
    horizontalSpacing: 20,
    positionX: 'right',
    positionY: 'top'
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
  'NotificationProvider','cfpLoadingBarProvider'
]


angular
.module("app")
.config appConfig


angular.element(document).ready ()->
  angular.bootstrap document, ['app'], strictDi : true